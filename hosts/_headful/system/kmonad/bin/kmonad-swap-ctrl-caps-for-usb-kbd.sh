#!/usr/bin/env bash
KM_PIDS=()
KBD_CONFIG=$(cat <<'EOF'
(defcfg
    input  (device-file "$KBD_DEV")
    output (uinput-sink "kmonad-$KBD_DEV")
    fallthrough true
    cmp-seq lctl
)
(defsrc
    caps lctl
)
(deflayer base
    lctl caps
)
EOF
)
cleanup_kmonad() {
    for pid in "${KM_PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid"
        fi
    done
    KM_PIDS=()
}
reload_kmonad() {
    cleanup_kmonad
    local devices
    devices=$(find /dev/input/by-id -type l -name "*kbd*" \( -name "*keyboard*" -o -name "*Keyboard*" \) ! \( -name "*mouse*" -o -name "*Mouse*" \) 2>/dev/null)
    [[ -z "$devices" ]] && return 1
    while IFS= read -r device; do
        [[ -L "$device" && -c "$(readlink -f "$device")" ]] || continue
        export KBD_DEV="$device"
        CONFIG_FILE=$(echo "$KBD_CONFIG" | envsubst)
        echo "$device"
        kmonad <(echo "$CONFIG_FILE") &
        KM_PIDS+=($!)
    done <<< "$devices"
}
trap cleanup_kmonad EXIT INT TERM
reload_kmonad
inotifywait -m /dev/input/by-id -e create -e delete --format '%f' 2>/dev/null |
while read -r file; do
    [[ "$file" =~ kbd ]] && [[ "$file" =~ [Kk]eyboard ]] && [[ ! "$file" =~ [Mm]ouse ]] || continue
    reload_kmonad
done
