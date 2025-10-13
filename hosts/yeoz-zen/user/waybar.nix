{ config, lib, pkgs, isLabtop, ... }: let

  fanPolicyPath = "/sys/devices/platform/asus-nb-wmi/throttle_thermal_policy";

  general = builtins.readFile ../../_headful/user/graphical-env/sway/waybar/css/general.css;
  warning = builtins.readFile ../../_headful/user/graphical-env/sway/waybar/css/warning.css;
  critical = builtins.readFile ../../_headful/user/graphical-env/sway/waybar/css/critical.css;
  conspicuous = builtins.readFile ../../_headful/user/graphical-env/sway/waybar/css/conspicuous.css;
  good = builtins.readFile ../../_headful/user/graphical-env/sway/waybar/css/good.css;

  getFanMode = pkgs.writeShellScript "get-fan-mode" ''
    #!/usr/bin/env bash
    output_json() {
      case $(cat ${fanPolicyPath} 2>/dev/null || echo "0") in
        0) echo '{"class":"normal","tooltip":"Normal"}' ;;
        1) echo '{"class":"overboost","tooltip":"Overboost"}' ;;
        2) echo '{"class":"silent","tooltip":"Silent"}' ;;
        *) echo '{"class":"unknown","tooltip":"Unknown"}' ;;
      esac
    }

    output_json
  '';
  defaultSettings = import ../../_headful/user/graphical-env/sway/waybar/settings.nix { inherit lib pkgs isLabtop; };
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
        format = "FAN";
        signal = 9;
        interval = "once";
        tooltip = "{tooltip}";
      };
    };
  in [
    finalSettings
  ];

  programs.waybar.style = lib.mkAfter (
    "#custom-fan-mode" + general + "#custom-fan-mode.normal" + warning + "#custom-fan-mode.overboost" + critical + "#custom-fan-mode.silent" + good + "custom-fan-mode.unknown" + conspicuous
  );
}

