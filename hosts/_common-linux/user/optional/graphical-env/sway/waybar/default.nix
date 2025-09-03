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
  ];

  wayland.windowManager.sway.config.bars = [{ command = "waybar"; }];
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 1;
      spacing = 5;

      modules-left = [ "sway/workspaces" "sway/mode" "memory" "cpu" ];
      modules-center = [ "clock" ];
      modules-right = [ "idle_inhibitor" "wireplumber" "backlight" "network" "bluetooth" "custom/battery-status" "tray" ];

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
        format = "{}";
        signal = 8;
        interval = 90;
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

      "temperature" = {
        hwmon-path = [ "/sys/class/hwmon/hwmon3/temp1_input" ];
        format = "TMP {temperatureC}°C";
        critical-threshold = 80;
        format-critical = "HOT {temperatureC}°C";
      };

      "network" = {
        format = "NET?";
        format-ethernet = "{ifname}";
        format-wifi = "{ifname} {signalStrength}%";
        format-linked = "{ifname}?";
        format-disconnected = "{ifname}-";
        format-disabled = "{ifname}-";
        tooltip-format = "Unknown state";
        tooltip-format-ethernet = "IP: {ipaddr}\nGateway: {gwaddr}";
        tooltip-format-wifi = "SSID: {essid}\nIP: {ipaddr}\nGateway: {gwaddr}";
        tooltip-format-disconnected = "offline";
        tooltip-format-disabled = "{ifname} has been blocked by rfkill or something else.";
        on-click = "${pkgs.kitty}/bin/kitty nmtui";
      };

      "bluetooth" = {
        # 基本格式设置
        format = "BT";                    # 开启状态，无连接设备
        format-disabled = "BT-";          # 控制器被禁用
        format-off = "BT-";               # 控制器关闭但未禁用
        format-on = "BT";                 # 开启状态，无连接设备
        format-connected = "BT+";         # 开启状态，已连接设备
        format-connected-battery = "BT+"; # 已连接设备且有电量信息
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
    }];
    style = ''
      * {
        font-family: JetBrainsMono Nerd Font;
        font-size: 12px;
        padding: 0;
        margin: 0;
        border: none;
      }

      window#waybar {
        color: #f8f8f2;
        background-color: rgba(40, 42, 54, 0.85);
        border: 1px solid rgba(189, 147, 249, 0.6);
        border-radius: 6px;
        margin: 3px 10px 0px 10px;
      }

      /* 工作区样式 */
      #workspaces,
      #mode {
        background-color: rgba(68, 71, 90, 0.4);
        border-radius: 4px;
        padding: 0px 3px;
        margin: 1px;
      }

      #mode {
        background-color: rgba(255,0,255,0.2);
        color: #ff00ff;
      }

      #workspaces button {
        color: #6272a4;
        padding: 0px 5px;
        font-size: 12px;
        border-radius: 3px;
        background-color: transparent;
      }

      #workspaces button:hover {
        background-color: rgba(189, 147, 249, 0.3);
        color: #bd93f9;
      }

      #workspaces button.focused {
        color: #f8f8f2;
        font-size: 13px;
        font-weight: bold;
        background-color: rgba(189, 147, 249, 0.5);
      }

      #workspaces button.visible {
        color: #50fa7b;
        background-color: rgba(80, 250, 123, 0.2);
      }

      #workspaces button.urgent {
        color: #ff5555;
        background-color: rgba(255, 85, 85, 0.3);
      }

      /* 通用模块样式 - 合并了系统监控、时钟和右侧模块 */
      #memory,
      #temperature,
      #cpu,
      #clock,
      #wireplumber,
      #custom-battery-status,
      #idle_inhibitor,
      #network,
      #bluetooth,
      #backlight,
      #tray {
        color: #f8f8f2;
        background-color: rgba(68, 71, 90, 0.4);
        border-radius: 4px;
        margin: 1px;
        padding: 0px 5px;
      }

      /* 时钟特殊样式 */
      #clock {
        font-weight: 500;
        padding: 0px 6px;
      }

      /* 警告状态 */
      #memory.warning,
      #cpu.warning {
        color: #f1fa8c;
        background-color: rgba(241, 250, 140, 0.2);
      }

      /* 危险状态 */
      #memory.critical,
      #cpu.critical,
      #temperature.critical {
        color: #ff5555;
        background-color: rgba(255, 85, 85, 0.2);
      }

      /* 电池模块状态 */
      #custom-battery-status.good {
        background-color: rgba(139, 233, 253, 0.3);
        color: #8be9fd;
      }

      #custom-battery-status.warning {
        background-color: rgba(241, 250, 140, 0.3);
        color: #f1fa8c;
      }

      #custom-battery-status.critical {
        background-color: rgba(255, 85, 85, 0.3);
        color: #ff5555;
      }

      #custom-battery-status.charging {
        background-color: rgba(80, 250, 123, 0.3);
        color: #50fa7b;
      }

      /* 音量模块 */
      #wireplumber.muted {
        color: #6272a4;
        background-color: rgba(98, 114, 164, 0.2);
      }

      /* 网络模块 */
      #network.disconnected {
        color: #6272a4;
        background-color: rgba(98, 114, 164, 0.2);
      }

      #network.wifi,
      #network.ethernet {
        background-color: rgba(80, 250, 123, 0.2);
        color: #50fa7b;
      }

      /* 蓝牙模块 */
      #bluetooth.no-controller {
        color: #f1fa8c;
        background-color: rgba(241, 250, 140, 0.2);
      }

      #network.disabled,
      #bluetooth.disabled {
        color: #44475a;
        background-color: rgba(68, 71, 90, 0.1);
        opacity: 0.5;
      }

      #bluetooth.off {
        color: #6272a4;
        background-color: rgba(98, 114, 164, 0.2);
      }

      #bluetooth.connected {
        color: #50fa7b;
        background-color: rgba(80, 250, 123, 0.2);
      }

      /* 睡眠抑制模块 */
      #idle_inhibitor.activated {
        color: #f1fa8c;
        background-color: rgba(241, 250, 140, 0.2);
      }

      #idle_inhibitor.deactivated {
        color: #6272a4;
        background-color: rgba(98, 114, 164, 0.2);
      }

      /* 托盘模块特殊样式 */
      #tray {
        padding: 0px 3px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: rgba(255, 85, 85, 0.3);
        border-radius: 3px;
      }
    '';
  };
}
