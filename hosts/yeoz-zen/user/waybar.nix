{ config, lib, pkgs, ... }: let
  great = builtins.readFile ../../_common-linux-labtop/user/graphical-env/sway/waybar/css/great.css;
  warning = builtins.readFile ../../_common-linux-labtop/user/graphical-env/sway/waybar/css/warning.css;
  critical = builtins.readFile ../../_common-linux-labtop/user/graphical-env/sway/waybar/css/critical.css;
  general = builtins.readFile ../../_common-linux-labtop/user/graphical-env/sway/waybar/css/general.css;

  fanPolicyPath = "/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy";
  
  getFanMode = pkgs.writeShellScript "get-fan-mode" ''
    #!/usr/bin/env bash
    get_mode_name() {
      case $1 in
        0) echo "Normal" ;;
        1) echo "Overboost" ;;
        2) echo "Silent" ;;
        *) echo "Unknown" ;;
      esac
    }

    output_json() {
      local mode=$(cat ${fanPolicyPath} 2>/dev/null || echo "0")
      local mode_name=$(get_mode_name $mode)
      echo "{\"text\":\"$mode_name\"}"
    }

    # Output initial state
    output_json

    # Monitor file changes with inotify
    ${pkgs.inotify-tools}/bin/inotifywait -m -e modify ${fanPolicyPath} 2>/dev/null | while read; do
      output_json
    done
  '';

  changeFanMode = pkgs.writeShellScript "change-fan-mode" ''
    #!/usr/bin/env bash
    current_mode=$(cat ${fanPolicyPath} 2>/dev/null || echo "0")
    
    case $current_mode in
      0) new_mode=1 ;;  # Normal -> Overboost
      1) new_mode=2 ;;  # Overboost -> Silent
      2) new_mode=0 ;;  # Silent -> Normal
      *) new_mode=0 ;;  # Unknown -> Normal
    esac
    
    echo $new_mode | sudo tee ${fanPolicyPath} > /dev/null
    ${pkgs.procps}/bin/pkill -RTMIN+9 waybar
  '';

in {

  programs.waybar.settings = let
    oldSettings = map (i: i // { }) (builtins.elemAt config.programs.waybar.settings 0);
    old-modules-left = map (i: i // { }) (lib.attrsets.getAttrs [ "modules-left" ] oldSettings
    newSettings = (oldSettings // {
      modules-left = old-modules-left ++ [ "custom/fan-mode" ];
      "custom/fan-mode" = { 
        exec = getFanMode;
        return-type = "json";
        format = "Fan Mode: {text}";
        signal = 9;
        interval = "once";
      };
    });
  in [ newSettings ];

  programs.waybar.style =
    config.programs.waybar.style
    + "#custom-fan-mode" + general
    + "#custom-fan-mode.normal" + warning
    + "#custom-fan-mode.silent" + great
    + "#custom-fan-mode.overboost" + critical;

}
