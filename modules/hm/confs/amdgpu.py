#!/usr/bin/env python3
"""
Lightweight AMD GPU info helper for HyDE/Waybar.

It prefers the pyamdgpuinfo library when available; otherwise it falls back to
reading sysfs so it works on minimal installations without extra Python deps.
"""
from __future__ import annotations

import json
from pathlib import Path


def try_pyamdgpuinfo() -> dict | None:
    try:
        import pyamdgpuinfo  # type: ignore
    except Exception:
        return None

    gpus = pyamdgpuinfo.detect_gpus()
    if gpus == 0:
        return None

    gpu = pyamdgpuinfo.get_gpu(0)
    return {
        "GPU Temperature": f"{gpu.query_temperature():.0f}°C",
        "GPU Load": f"{gpu.query_load():.1f}%",
        "GPU Core Clock": fmt_freq(gpu.query_sclk()),
        "GPU Power Usage": f"{gpu.query_power():.1f} Watts",
    }


def fmt_freq(hz: int) -> str:
    units = ["Hz", "KHz", "MHz", "GHz", "THz"]
    value = float(hz)
    i = 0
    while value >= 1000 and i < len(units) - 1:
        value /= 1000
        i += 1
    return f"{value:.0f} {units[i]}"


def first_existing(paths: list[Path]) -> Path | None:
    for p in paths:
        if p.exists():
            return p
    return None


def read_number(path: Path, scale: float = 1.0) -> float | None:
    try:
        with path.open() as f:
            raw = f.read().strip().split()[0]
        return float(raw) / scale
    except Exception:
        return None


def sysfs_card() -> Path | None:
    drm_dir = Path("/sys/class/drm")
    for card in drm_dir.glob("card[0-9]*"):
        vendor = (card / "device/vendor").read_text().strip() if (card / "device/vendor").exists() else ""
        if vendor.lower() == "0x1002":  # AMD vendor id
            return card
    return None


def query_sysfs() -> dict | None:
    card = sysfs_card()
    if not card:
        return None

    dev = card / "device"
    hwmon_dir = first_existing(sorted((dev / "hwmon").glob("hwmon*")))

    temp = read_number(hwmon_dir / "temp1_input", scale=1000) if hwmon_dir else None
    power = read_number(hwmon_dir / "power1_average", scale=1_000_000) if hwmon_dir and (hwmon_dir / "power1_average").exists() else None
    load = read_number(dev / "gpu_busy_percent")  # already in percent

    sclk = None
    dpm_path = dev / "pp_dpm_sclk"
    if dpm_path.exists():
        try:
            for line in dpm_path.read_text().splitlines():
                if "*" in line:
                    # line example: "1: 800Mhz *"
                    parts = line.split()
                    for part in parts:
                        if part.lower().endswith("mhz"):
                            sclk = part.upper().replace("MHZ", " MHz")
                            break
                    break
        except Exception:
            pass

    # Compose only if we have at least temperature or load; otherwise bail
    if all(v is None for v in (temp, load, sclk, power)):
        return None

    return {
        "GPU Temperature": f"{temp:.0f}°C" if temp is not None else "N/A",
        "GPU Load": f"{load:.1f}%" if load is not None else "N/A",
        "GPU Core Clock": sclk or "N/A",
        "GPU Power Usage": f"{power:.1f} Watts" if power is not None else "N/A",
    }


def main() -> None:
    data = try_pyamdgpuinfo() or query_sysfs()
    if not data:
        print("Unknown query failure")
        return
    print(json.dumps(data, ensure_ascii=False))


if __name__ == "__main__":
    main()
