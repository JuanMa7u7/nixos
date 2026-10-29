#!/usr/bin/env python3

from pathlib import Path
import sys


CPU_RESOURCE = (
    '            warningThreshold: Config.options.bar.resources.cpuWarningThreshold\n'
    '        }\n'
)
CPU_POPUP = (
    '        Column {\n'
    '            anchors.top: parent.top\n'
    '            spacing: 8\n'
    '\n'
    '            StyledPopupHeaderRow {\n'
    '                icon: "planner_review"\n'
    '                label: "CPU"\n'
    '            }\n'
    '            Column {\n'
    '                spacing: 4\n'
    '                StyledPopupValueRow {\n'
    '                    icon: "bolt"\n'
    '                    label: Translation.tr("Load:")\n'
    '                    value: `${Math.round(ResourceUsage.cpuUsage * 100)}%`\n'
    '                }\n'
    '            }\n'
    '        }\n'
)
OLD_GPU_POPUP = (
    '        Column {\n'
    '            visible: GpuUsage.available\n'
    '            anchors.top: parent.top\n'
    '            spacing: 8\n'
    '\n'
    '            StyledPopupHeaderRow {\n'
    '                icon: "developer_board"\n'
    '                label: "GPU"\n'
    '            }\n'
    '            Column {\n'
    '                spacing: 4\n'
    '                StyledPopupValueRow {\n'
    '                    icon: "bolt"\n'
    '                    label: Translation.tr("Load:")\n'
    '                    value: `${Math.round(GpuUsage.utilization * 100)}%`\n'
    '                }\n'
    '            }\n'
    '        }\n'
)


def patch_resource_file(path: Path) -> None:
    source = path.read_text()
    if "GpuUsage.utilization" in source:
        return

    if source.count(CPU_RESOURCE) != 1:
        raise SystemExit(f"Could not find the expected CPU resource in {path}")

    if path.parent.name == "verticalBar":
        gpu_resource = (
            '\n        Resource {\n'
            '            Layout.alignment: Qt.AlignHCenter\n'
            '            iconName: "developer_board"\n'
            '            percentage: GpuUsage.utilization\n'
            '            visible: GpuUsage.available\n'
            '        }\n'
        )
    else:
        gpu_resource = (
            '\n        Resource {\n'
            '            iconName: "developer_board"\n'
            '            percentage: GpuUsage.utilization\n'
            '            shown: GpuUsage.available\n'
            '            Layout.leftMargin: shown ? 6 : 0\n'
            '        }\n'
        )

    path.write_text(source.replace(CPU_RESOURCE, CPU_RESOURCE + gpu_resource, 1))


def patch_popup_file(path: Path) -> None:
    source = path.read_text()
    if "GpuUsage.cpuName" in source:
        return

    if source.count(CPU_POPUP) != 1:
        raise SystemExit(f"Could not find the expected CPU popup in {path}")

    cpu_column = (
        '        Column {\n'
        '            anchors.top: parent.top\n'
        '            spacing: 8\n'
        '\n'
        '            StyledPopupHeaderRow {\n'
        '                icon: "planner_review"\n'
        '                label: "CPU"\n'
        '            }\n'
        '            Column {\n'
        '                spacing: 4\n'
        '                StyledPopupValueRow {\n'
        '                    icon: "developer_board"\n'
        '                    label: Translation.tr("Name:")\n'
        '                    value: GpuUsage.cpuName || "N/A"\n'
        '                }\n'
        '                StyledPopupValueRow {\n'
        '                    icon: "bolt"\n'
        '                    label: Translation.tr("Load:")\n'
        '                    value: `${Math.round(ResourceUsage.cpuUsage * 100)}%`\n'
        '                }\n'
        '                StyledPopupValueRow {\n'
        '                    icon: "device_thermostat"\n'
        '                    label: Translation.tr("Temperature:")\n'
        '                    value: GpuUsage.cpuTemperatureC >= 0 ? `${GpuUsage.cpuTemperatureC.toFixed(0)} °C` : "N/A"\n'
        '                }\n'
        '                StyledPopupValueRow {\n'
        '                    icon: "speed"\n'
        '                    label: Translation.tr("Clock Speed:")\n'
        '                    value: GpuUsage.cpuClockMHz > 0 ? `${(GpuUsage.cpuClockMHz / 1000).toFixed(2)} GHz` : "N/A"\n'
        '                }\n'
        '            }\n'
        '        }\n'
    )
    gpu_column = (
        '\n        Column {\n'
        '            visible: GpuUsage.available\n'
        '            anchors.top: parent.top\n'
        '            spacing: 8\n'
        '\n'
        '            StyledPopupHeaderRow {\n'
        '                icon: "developer_board"\n'
        '                label: "GPU"\n'
        '            }\n'
        '            Column {\n'
        '                spacing: 4\n'
        '                StyledPopupValueRow {\n'
        '                    icon: "developer_board"\n'
        '                    label: Translation.tr("Name:")\n'
        '                    value: GpuUsage.gpuName || "N/A"\n'
        '                }\n'
        '                StyledPopupValueRow {\n'
        '                    icon: "bolt"\n'
        '                    label: Translation.tr("Load:")\n'
        '                    value: `${Math.round(GpuUsage.utilization * 100)}%`\n'
        '                }\n'
        '                StyledPopupValueRow {\n'
        '                    icon: "device_thermostat"\n'
        '                    label: Translation.tr("Temperature:")\n'
        '                    value: GpuUsage.gpuTemperatureC >= 0 ? `${GpuUsage.gpuTemperatureC.toFixed(0)} °C` : "N/A"\n'
        '                }\n'
        '                StyledPopupValueRow {\n'
        '                    icon: "memory"\n'
        '                    label: Translation.tr("VRAM Usage:")\n'
        '                    value: GpuUsage.gpuVramTotalMiB > 0 ? `${(GpuUsage.gpuVramUsedMiB / 1024).toFixed(1)} / ${(GpuUsage.gpuVramTotalMiB / 1024).toFixed(1)} GiB` : "N/A"\n'
        '                }\n'
        '            }\n'
        '        }\n'
    )

    source = source.replace(CPU_POPUP, cpu_column, 1)
    if source.count(OLD_GPU_POPUP) == 1:
        source = source.replace(OLD_GPU_POPUP, gpu_column.lstrip("\n").rstrip("\n") + "\n", 1)
    elif "GpuUsage.utilization" not in source:
        source = source.replace(cpu_column, cpu_column + gpu_column, 1)
    else:
        raise SystemExit(f"Could not find the existing GPU popup in {path}")
    path.write_text(source)


if len(sys.argv) < 2:
    raise SystemExit("Pass Illogical Impulse resource or popup QML paths")

for resource_path in map(Path, sys.argv[1:]):
    if resource_path.name == "ResourcesPopup.qml":
        patch_popup_file(resource_path)
    else:
        patch_resource_file(resource_path)
