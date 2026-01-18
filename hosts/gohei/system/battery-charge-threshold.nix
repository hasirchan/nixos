{ pkgs, ... }:
{
  systemd.services.battery-charge-threshold-auto = {
    description = "Set battery charge control end threshold to 60% (auto-detect)";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeScript "set-battery-threshold-auto" ''
        #!${pkgs.bash}/bin/bash
        set -e

        THRESHOLD_VALUE=60

        for bat_path in /sys/class/power_supply/BAT*/charge_control_end_threshold; do
          if [ -f "$bat_path" ]; then
            echo "Found battery threshold file: $bat_path"
            echo "Setting battery charge threshold to $THRESHOLD_VALUE%"
            echo $THRESHOLD_VALUE > "$bat_path"
            echo "Battery charge threshold set successfully"
            exit 0
          fi
        done

        SPECIFIC_PATH="/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT1/charge_control_end_threshold"
        if [ -f "$SPECIFIC_PATH" ]; then
          echo "Using specific path: $SPECIFIC_PATH"
          echo $THRESHOLD_VALUE > "$SPECIFIC_PATH"
          echo "Battery charge threshold set successfully"
        else
          echo "Warning: No battery threshold files found"
          exit 1
        fi
      '';
      User = "root";
    };
  };
}
