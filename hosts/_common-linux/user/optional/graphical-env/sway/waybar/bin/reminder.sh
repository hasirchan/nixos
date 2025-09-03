#!/usr/bin/env bash

send_signal() {
    pid=$(pgrep waybar)
    if [ -z "$pid" ]; then
        echo "waybar process not found" >&2
        return
    fi
    kill -SIGRTMIN+8 "$pid"
}

udevadm monitor --subsystem-match=net --subsystem-match=bluetooth --subsystem-match=power_supply --udev |
while read -r line; do
    case "$line" in
        *power_supply*)
            case "$line" in
                *BAT*) ;;
                *) send_signal ;;
            esac
            ;;
    esac
done
