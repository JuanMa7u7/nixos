pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property bool available: false
    property real utilization: 0
    property string cpuName: ""
    property real cpuTemperatureC: -1
    property real cpuClockMHz: -1
    property string gpuName: ""
    property real gpuTemperatureC: -1
    property real gpuVramUsedMiB: -1
    property real gpuVramTotalMiB: -1

    function parseMetric(value) {
        if (value === undefined || value.trim().length === 0) return -1;
        const number = Number(value);
        return Number.isFinite(number) ? number : -1;
    }

    Process {
        id: gpuUsageProcess
        command: [
            "bash",
            "-c",
            "exec \"$HOME/.config/quickshell/ii/scripts/gpu-usage.sh\""
        ]
        running: true

        stdout: StdioCollector {
            id: outputCollector

            onStreamFinished: {
                const metrics = {};
                for (const line of outputCollector.text.split(/\r?\n/)) {
                    const separator = line.indexOf("=");
                    if (separator > 0) {
                        metrics[line.slice(0, separator)] = line.slice(separator + 1).trim();
                    }
                }

                root.cpuName = metrics.cpu_name ?? "";
                root.cpuTemperatureC = root.parseMetric(metrics.cpu_temperature_c);
                root.cpuClockMHz = root.parseMetric(metrics.cpu_clock_mhz);
                root.gpuName = metrics.gpu_name ?? "";
                root.gpuTemperatureC = root.parseMetric(metrics.gpu_temperature_c);
                root.gpuVramUsedMiB = root.parseMetric(metrics.gpu_vram_used_mib);
                root.gpuVramTotalMiB = root.parseMetric(metrics.gpu_vram_total_mib);

                const gpuLoad = root.parseMetric(metrics.gpu_load);
                root.available = root.gpuName.length > 0 && gpuLoad >= 0 && gpuLoad <= 100;
                if (root.available) root.utilization = gpuLoad / 100;
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            if (!gpuUsageProcess.running) gpuUsageProcess.running = true;
        }
    }
}
