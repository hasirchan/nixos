#!/usr/bin/env bash

fanPolicyPath="/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy"

send_signal() {
    pid=$(pgrep waybar)
    if [ -z "$pid" ]; then
        echo "waybar process not found" >&2
        return
    fi
    kill -SIGRTMIN+9 "$pid"
}

inotifywait -m -e modify "$fanPolicyPath" 2>/dev/null |
while read -r path event file; do
    send_signal
done
