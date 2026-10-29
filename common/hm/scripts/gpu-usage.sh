#!/usr/bin/env bash

# Emit CPU and first-GPU telemetry for the QuickShell popup. Prefer NVIDIA
# telemetry when available; otherwise read AMD amdgpu sysfs metrics. Missing
# sensor fields are empty, while missing GPU load hides the GPU indicator.

set -u
shopt -s nullglob

trim() {
  local value="${1-}"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

is_valid_percentage() {
  [[ "$1" =~ ^[0-9]{1,3}$ ]] && (( 10#$1 <= 100 ))
}

is_valid_integer() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

to_celsius() {
  awk -v milli="$1" 'BEGIN { printf "%.1f", milli / 1000 }'
}

to_mib() {
  awk -v bytes="$1" 'BEGIN { printf "%.0f", bytes / 1048576 }'
}

read_cpu_temperature() {
  local hwmon sensor label input value fallback=""

  for hwmon in /sys/class/hwmon/hwmon*; do
    [[ -r "$hwmon/name" ]] || continue
    sensor="$(<"$hwmon/name")"
    case "$sensor" in
      k10temp|zenpower|coretemp|thinkpad) ;;
      *) continue ;;
    esac

    fallback=""
    for input in "$hwmon"/temp*_input; do
      [[ -r "$input" ]] || continue
      value="$(<"$input")"
      [[ "$value" =~ ^[0-9]+$ ]] || continue
      (( 10#$value >= 10000 && 10#$value <= 150000 )) || continue

      label=""
      [[ -r "${input%_input}_label" ]] && label="$(<"${input%_input}_label")"
      [[ -n "$fallback" ]] || fallback="$value"

      case "$sensor:$label" in
        k10temp:Tctl|zenpower:Tdie|coretemp:"Package id 0"|thinkpad:CPU)
          printf '%s' "$value"
          return
          ;;
      esac
    done

    if [[ -n "$fallback" ]]; then
      printf '%s' "$fallback"
      return
    fi
  done
}

cpu_name="$(awk -F: '/^model name[[:space:]]*:/ { sub(/^[[:space:]]+/, "", $2); print $2; exit }' /proc/cpuinfo)"
cpu_clock_mhz="$(awk -F: '/^cpu MHz[[:space:]]*:/ { gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); total += $2; count++ } END { if (count) printf "%.0f", total / count }' /proc/cpuinfo)"

if [[ -z "$cpu_clock_mhz" ]]; then
  cpu_frequency_files=(/sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq)
  if (( ${#cpu_frequency_files[@]} > 0 )); then
    cpu_clock_mhz="$(awk '{ total += $1; count++ } END { if (count) printf "%.0f", total / count / 1000 }' "${cpu_frequency_files[@]}")"
  fi
fi

cpu_temperature_milli="$(read_cpu_temperature)"
cpu_temperature_c=""
if is_valid_integer "$cpu_temperature_milli"; then
  cpu_temperature_c="$(to_celsius "$cpu_temperature_milli")"
fi

gpu_name=""
gpu_load=""
gpu_temperature_c=""
gpu_vram_used_mib=""
gpu_vram_total_mib=""

if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia_row="$(nvidia-smi --query-gpu=name,utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null | head -n 1 || true)"
  nvidia_name=""
  nvidia_load=""
  nvidia_temperature=""
  nvidia_used=""
  nvidia_total=""
  IFS=',' read -r nvidia_name nvidia_load nvidia_temperature nvidia_used nvidia_total <<< "$nvidia_row"
  nvidia_name="$(trim "${nvidia_name-}")"
  nvidia_load="$(trim "${nvidia_load-}")"
  nvidia_temperature="$(trim "${nvidia_temperature-}")"
  nvidia_used="$(trim "${nvidia_used-}")"
  nvidia_total="$(trim "${nvidia_total-}")"

  if is_valid_percentage "$nvidia_load"; then
    gpu_name="${nvidia_name:-NVIDIA GPU}"
    gpu_load="$nvidia_load"
    is_valid_integer "$nvidia_temperature" && gpu_temperature_c="$nvidia_temperature"
    if is_valid_integer "$nvidia_used" && is_valid_integer "$nvidia_total"; then
      gpu_vram_used_mib="$nvidia_used"
      gpu_vram_total_mib="$nvidia_total"
    fi
  fi
fi

if [[ -z "$gpu_load" ]]; then
  for card in /sys/class/drm/card[0-9]*; do
    [[ "${card##*/}" =~ ^card[0-9]+$ ]] || continue
    device="$card/device"
    metric="$device/gpu_busy_percent"
    [[ -r "$metric" ]] || continue

    value="$(<"$metric")"
    is_valid_percentage "$value" || continue

    gpu_load="$value"
    if [[ -r "$device/product_name" ]]; then
      gpu_name="$(trim "$(<"$device/product_name")")"
    fi
    if [[ -z "$gpu_name" ]] && command -v lspci >/dev/null 2>&1; then
      pci_slot="$(basename "$(readlink -f "$device" 2>/dev/null)")"
      gpu_name="$(lspci -s "$pci_slot" -mm 2>/dev/null | awk -F '"' 'NF >= 6 { print $4 " " $6; exit }' || true)"
      gpu_name="$(trim "$(sed -E 's/ \[[^]]*\]//g' <<< "$gpu_name")")"
    fi
    [[ -n "$gpu_name" ]] || gpu_name="AMD GPU"

    temperature_fallback=""
    for hwmon in "$device"/hwmon/hwmon*; do
      [[ -r "$hwmon/name" ]] || continue
      [[ "$(<"$hwmon/name")" == "amdgpu" ]] || continue
      for input in "$hwmon"/temp*_input; do
        [[ -r "$input" ]] || continue
        value="$(<"$input")"
        [[ "$value" =~ ^[0-9]+$ ]] || continue
        (( 10#$value >= 10000 && 10#$value <= 150000 )) || continue
        label=""
        [[ -r "${input%_input}_label" ]] && label="$(<"${input%_input}_label")"
        [[ -n "$temperature_fallback" ]] || temperature_fallback="$value"
        if [[ "$label" == "edge" ]]; then
          temperature_fallback="$value"
          break
        fi
      done
      [[ -n "$temperature_fallback" ]] && break
    done
    if [[ -n "$temperature_fallback" ]]; then
      gpu_temperature_c="$(to_celsius "$temperature_fallback")"
    fi

    if [[ -r "$device/mem_info_vram_used" && -r "$device/mem_info_vram_total" ]]; then
      vram_used_bytes="$(<"$device/mem_info_vram_used")"
      vram_total_bytes="$(<"$device/mem_info_vram_total")"
      if is_valid_integer "$vram_used_bytes" && is_valid_integer "$vram_total_bytes"; then
        gpu_vram_used_mib="$(to_mib "$vram_used_bytes")"
        gpu_vram_total_mib="$(to_mib "$vram_total_bytes")"
      fi
    fi
    break
  done
fi

printf 'cpu_name=%s\n' "$cpu_name"
printf 'cpu_temperature_c=%s\n' "$cpu_temperature_c"
printf 'cpu_clock_mhz=%s\n' "$cpu_clock_mhz"
printf 'gpu_name=%s\n' "$gpu_name"
printf 'gpu_load=%s\n' "$gpu_load"
printf 'gpu_temperature_c=%s\n' "$gpu_temperature_c"
printf 'gpu_vram_used_mib=%s\n' "$gpu_vram_used_mib"
printf 'gpu_vram_total_mib=%s\n' "$gpu_vram_total_mib"
