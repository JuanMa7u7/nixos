#!/usr/bin/env bash
# Repo-owned copy of end-4's quickshell/ii/scripts/videos/record.sh, deployed
# over the upstream file by the fixRecordScript activation hook (the upstream
# copyIllogicalImpulseConfigs entry rm -rf's the destination on every switch).
# Deltas vs upstream:
#  - getaudiooutput():2>/dev/null + head -n1 (pactl missing -> empty, and
#    multi-monitor yields multiple source names which break --audio=)
#  - --sound falls back to plain --audio (default source) when device
#    detection fails; upstream passes --audio="" which makes wf-recorder
#    0.6.0 abort (Assertion 'p' failed in pa_simple_get_latency, core dump)
#  - dropped -t (unsupported by wf-recorder 0.6.0; prints "invalid option")

CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"
JSON_PATH=".screenRecord.savePath"

CUSTOM_PATH=$(jq -r "$JSON_PATH" "$CONFIG_FILE" 2>/dev/null)

RECORDING_DIR=""

if [[ -n "$CUSTOM_PATH" ]]; then
    RECORDING_DIR="$CUSTOM_PATH/Recordings"
else
    RECORDING_DIR="$HOME/Videos/Recordings" # Use default path
fi

getdate() {
    date '+%Y-%m-%d_%H.%M.%S'
}
getaudiooutput() {
    pactl list sources 2>/dev/null | grep 'Name' | grep 'monitor' | cut -d ' ' -f2 | head -n1
}
getactivemonitor() {
    hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'
}

mkdir -p "$RECORDING_DIR"
cd "$RECORDING_DIR" || exit

# parse --region <value> without modifying $@ so other flags like --fullscreen still work
ARGS=("$@")
MANUAL_REGION=""
SOUND_FLAG=0
FULLSCREEN_FLAG=0
for ((i=0;i<${#ARGS[@]};i++)); do
    if [[ "${ARGS[i]}" == "--region" ]]; then
        if (( i+1 < ${#ARGS[@]} )); then
            MANUAL_REGION="${ARGS[i+1]}"
        else
            notify-send "Recording cancelled" "No region specified for --region" -a 'Recorder' & disown
            exit 1
        fi
    elif [[ "${ARGS[i]}" == "--sound" ]]; then
        SOUND_FLAG=1
    elif [[ "${ARGS[i]}" == "--fullscreen" ]]; then
        FULLSCREEN_FLAG=1
    fi
done

# wf-recorder 0.6.0 aborts on --audio="" (invalid device); fall back to the
# default source when detection yields nothing.
AUDIO_ARGS=(--audio)
AUDIO_DEVICE="$(getaudiooutput)"
if [[ -n "$AUDIO_DEVICE" ]]; then
    AUDIO_ARGS=(--audio="$AUDIO_DEVICE")
fi

if pgrep wf-recorder > /dev/null; then
    notify-send "Recording Stopped" "Stopped" -a 'Recorder' &
    pkill wf-recorder &
else
    if [[ $FULLSCREEN_FLAG -eq 1 ]]; then
        notify-send "Starting recording" 'recording_'"$(getdate)"'.mp4' -a 'Recorder' & disown
        if [[ $SOUND_FLAG -eq 1 ]]; then
            wf-recorder -o "$(getactivemonitor)" --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' "${AUDIO_ARGS[@]}"
        else
            wf-recorder -o "$(getactivemonitor)" --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4'
        fi
    else
        # If a manual region was provided via --region, use it; otherwise run slurp as before.
        if [[ -n "$MANUAL_REGION" ]]; then
            region="$MANUAL_REGION"
        else
            if ! region="$(slurp 2>&1)"; then
                notify-send "Recording cancelled" "Selection was cancelled" -a 'Recorder' & disown
                exit 1
            fi
        fi

        notify-send "Starting recording" 'recording_'"$(getdate)"'.mp4' -a 'Recorder' & disown
        if [[ $SOUND_FLAG -eq 1 ]]; then
            wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' --geometry "$region" "${AUDIO_ARGS[@]}"
        else
            wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' --geometry "$region"
        fi
    fi
fi