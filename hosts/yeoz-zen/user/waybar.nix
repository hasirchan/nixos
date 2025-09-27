{ config, lib, pkgs, ... }: let

  fanPolicyPath = "/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy";

  general = builtins.readFile ../../_headful/user/graphical-env/sway/waybar/css/general.css;  
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

  defaultSettings = import ../../_headful/user/graphical-env/sway/waybar/settings.nix { inherit lib pkgs;};
in {
  imports = [
    ./reminder.nix
  ];
  programs.waybar.settings = let 
    finalSettings = defaultSettings // {
      modules-left = defaultSettings.modules-left ++ ["custom/fan-mode"];

      "custom/fan-mode" = {
        exec = getFanMode;
        return-type = "json";
        format = "Fan Mode: {text}";
        signal = 9;
        interval = "once";
      };
    };
  in [
    finalSettings
  ];

  programs.waybar.style = lib.mkAfter (
    "#custom-fan-mode" + general
  );
}

