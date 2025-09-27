{ config, lib, pkgs, ... }: let

  fanPolicyPath = "/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy";

  general = builtins.readFile ../../_headful/user/graphical-env/sway/waybar/css/general.css;  

  getFanMode = pkgs.writeShellScript "get-fan-mode" ''
    #!/usr/bin/env bash
    output_json() {
      case $(cat ${fanPolicyPath} 2>/dev/null || echo "0") in
        0) echo '{"text":"+","tooltip":"Normal"}' ;;
        1) echo '{"text":"*","tooltip":"Overboost"}' ;;
        2) echo '{"text":"-","tooltip":"Silent"}' ;;
        *) echo '{"text":"?","tooltip":"Unknown"}' ;;
      esac
    }

    output_json
  '';
  defaultSettings = import ../../_headful/user/graphical-env/sway/waybar/settings.nix { inherit lib pkgs; };
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
        format = "FAN{text}";
        signal = 9;
        interval = "once";
        tooltip = "{tooltip}";
      };
    };
  in [
    finalSettings
  ];

  programs.waybar.style = lib.mkAfter (
    "#custom-fan-mode" + general
  );
}

