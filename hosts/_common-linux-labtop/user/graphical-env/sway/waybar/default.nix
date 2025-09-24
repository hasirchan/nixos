{ config, lib, pkgs, ... }: let 
  app = pkgs.symlinkJoin {
    name = "scripts";
    paths = with pkgs; [
      (writeShellScriptBin "waybar-battery-status" (builtins.readFile ./bin/battery-status.sh))
      upower
      coreutils
    ];
  };
in {

  imports = [
    ./reminder.nix
    ./style.nix
  ];

  wayland.windowManager.sway.config.bars = [{ command = "waybar"; }];
  programs.waybar = {
    enable = true;
    settings = [({
      layer = "top";
      position = "top";
      height = 1;
      spacing = 5;

      modules-left = [ "custom/menu" "sway/workspaces" "sway/mode" "memory" "cpu" ];
      modules-center = [ "clock" ];
      modules-right = [ "idle_inhibitor" "wireplumber" ] ++ lib.optionals true ["backlight"] ++ [ "network#1" "network#2" "bluetooth" ] ++ lib.optionals true ["custom/battery-status"] ++ [ "tray" ];

      "custom/menu" = {
        "format" = " ";
        "on-click" = "${pkgs.wofi}/bin/wofi --show drun";
        "on-click-right" = ''
          echo -e "Shutdown\nReboot" | ${pkgs.wofi}/bin/wofi --show dmenu | while read choice; do
            case "$choice" in
              "Shutdown") systemctl poweroff ;;
              "Reboot") systemctl reboot ;;
            esac
          done
        '';
        "tooltip" = false;
      };
      "sway/workspaces" = {
        format = "{name}";
        on-click = "activate";
        sort-by-number = true;
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
          "4" = [];
          "5" = [];
        };
      };

      "sway-mode" = {
        format = "";
      };

      "clock" = {
        format = "{:%d.%m.%Y | %H:%M:%S}";
        interval = 1;
        on-click = "${pkgs.kitty}/bin/kitty calcurse";
      };

      "wireplumber" = {
        format = "VOL {volume}%";
        format-muted = "MUT {volume}%";
        max-volume = 100;
        scroll-step = 5;
        on-click = "${pkgs.kitty}/bin/kitty wiremix";
      };

      "memory" = {
        interval = 5;
        format = "MEM {used:0.1f}G";
        states = {
          warning = 70;
          critical = 90;
        };
      };

      "cpu" = {
        interval = 2;
        format = "CPU {usage}%";
        states = {
          warning = 70;
          critical = 90;
        };
      };

      "network#1" = {
        interface = "w*";
        format-wifi = "{ifname} {signalStrength}%";
        format-linked = "{ifname}?";
        format-disconnected = "{ifname}";
        format-disabled = "{ifname}-";
        tooltip-format-wifi = "SSID: {essid}\nIP: {ipaddr}";
        tooltip-format-disconnected = "Offline";
        tooltip-format-disabled = "{ifname} has been blocked by rfkill or something else.";
        on-click = "${pkgs.kitty}/bin/kitty nmtui";
      };

      "network#2" = {
        interface = "e*";
        format-ethernet = "{ifname}+";
        format-linked = "{ifname}?";
        format-disconnected = "{ifname}";
        rfkill = false;
        tooltip-format-ethernet = "IP: {ipaddr}\n";
        tooltip-format-disconnected = "Offline";
        on-click = "${pkgs.kitty}/bin/kitty nmtui";
      };


      "bluetooth" = {
        # 基本格式设置
        format = "BT*";                    
        format-disabled = "BT-";          # 控制器被禁用
        format-off = "BT!";               # 控制器关闭但未禁用
        format-on = "BT";                 # 开启状态，无连接设备
        format-connected = "BT+";         # 开启状态，已连接设备
        format-connected-battery = "BT+ {device_battery_percentage}"; # 已连接设备且有电量信息
        format-no-controller = "BT?";     # 无蓝牙控制器
        on-click = "${pkgs.kitty}/bin/kitty bluetuith";
        # 更新间隔
        interval = 3;
      };

      "tray" = {
        icon-size = 16;
        spacing = 16;
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "AWK";
          deactivated = "SLP";
        };
      };
    } // lib.attrsets.optionalAttrs (true) {
      "backlight" = let 
        brightnessPlus = "${pkgs.brightnessctl}/bin/brightnessctl set +5%";
        brightnessMinus = "${pkgs.bash}/bin/bash -c 'current=$(${pkgs.brightnessctl}/bin/brightnessctl get); max=$(${pkgs.brightnessctl}/bin/brightnessctl max); if [ $((current * 100 / max - 5)) -lt 1 ]; then ${pkgs.brightnessctl}/bin/brightnessctl set 1%; else ${pkgs.brightnessctl}/bin/brightnessctl set 5%-; fi'";

      in {
        format = "BRT {percent}%";
        on-scroll-up = brightnessPlus;
        on-scroll-down = brightnessMinus;
        on-click = brightnessPlus;
        on-click-right = brightnessMinus; 
      };

      "custom/battery-status" = {
        exec = "${app}/bin/waybar-battery-status";
        return-type = "json";
        format = "BAT {percentage}%";
        signal = 8;
        interval = 90;
      };
    })];

  };
}
