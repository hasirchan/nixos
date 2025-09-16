{ config, lib, pkgs, ... } :
{

  imports = [
    # ./reminder.nix
  ];
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        settings = {
          theme = {
            theme = "plain";
            overrides = {
              idle_bg = "#282a36";
              idle_fg = "#ffffff";
              good_bg = "#50fa7b";
              good_fg = "#000000";
              info_bg = "#8be9fd";
              info_fg = "#000000";
              warning_bg = "#ffb86c";
              warning_fg = "#000000";
              critical_bg = "#ff5555";
              critical_fg = "#ffffff";
            };
          };
          icons = {
            icons = "none";
          };
        };
        blocks = let 
          app = pkgs.symlinkJoin {
            name = "scripts";
            paths = with pkgs; [
              (writeShellScriptBin "i3status-battery-status" (builtins.readFile ./bin/battery-status.sh))
              (writeShellScriptBin "i3status-bluetooth-status" (builtins.readFile ./bin/bluetooth-status.sh))
              upower
              bluez
            ];
          };
        in [
          
          {
            block = "cpu";
            format = "CPU $utilization";
            interval = 1;
            info_cpu = 30.0;
            warning_cpu = 70.0;
            critical_cpu = 90.0;
          }
          /*
          # 系统资源监控
          {
            block = "memory";
            format = "MEM $mem_used_percents";
            interval = 5;
            warning_mem = 80.0;
            critical_mem = 95.0;
          }
          {
            block = "disk_space";
            format = "DSK $percentage";
            path = "/";
            interval = 20;
            warning = 80.0;
            alert = 95.0;
          }

          # 系统负载
          {
            block = "load";
            format = "LOAD $1m.eng(w:4)";
            interval = 3;
            info = 1.0;
            warning = 2.0;
            critical = 5.0;
          }
          # 系统温度
          {
            block = "temperature";
            format = "TMP $max";
            interval = 4;
            good = 20.0;
            idle = 45.0;
            info = 60.0;
            warning = 80.0;
          }
          */

          {
            block = "custom";
            command = "echo CFG";
            interval = "once";
            format = " $text ";
            click = [
              {
                button = "left";
                cmd = ''
                  selection=$(echo -e "Network (nmtui)\nBluetooth (bluetuith)\nAudio (wiremix)" | ${pkgs.wofi}/bin/wofi --dmenu --prompt="Config" --width=300 --height=150)
                  case "$selection" in
                      "Network (nmtui)")
                          ${pkgs.kitty}/bin/kitty ${pkgs.networkmanager}/bin/nmtui &
                          ;;
                      "Bluetooth (bluetuith)")
                          ${pkgs.kitty}/bin/kitty ${pkgs.bluetuith}/bin/bluetuith &
                          ;;
                      "Audio (wiremix)")
                          ${pkgs.kitty}/bin/kitty ${pkgs.wiremix}/bin/wiremix &
                          ;;
                  esac
                '';
              }
            ];
          }
          
          # 网络连接 - WiFi
          {
            block = "net";
            device = "^wl.*";
            format = "$device $signal_strength";
            format_alt = "$device $ip $ipv6";
            inactive_format = "WIF-";
            missing_format = "";
            interval = 10;
          }
          
          # 网络连接 - 以太网
          {
            block = "net";
            device = "^(en|eth).*";
            format = "$device";
            format_alt = "$device $ip $ipv6";
            inactive_format = "ETH-";
            missing_format = "";
            interval = 10;
          }
          
          {
            block = "custom";
            command = "${app}/bin/i3status-bluetooth-status";
            interval = 10;
            format = " $text ";
          }
          
          
          # 音量控制
          {
            block = "sound";
            format = "VOL{ $volume|}";
            format_alt = "$output_name{ $volume|}";
            driver = "auto";
            step_width = 5;
            show_volume_when_muted = true;
          }
          
          # 屏幕亮度
          {
            block = "backlight";
            format = "BRT $brightness";
            device = ".*";  # 匹配任何背光设备
            step_width = 5;
            minimum = 0;
          }
          
          
          # 电池状态
          {
            block = "custom";
            interval = 90;
            json = true;
            command = "${app}/bin/i3status-battery-status";
          }
          
          {
            block = "time";
            format = "$timestamp.datetime(f:'%m-%d-%y %H:%M:%S')";
            interval = 1;
          }
        ];
      };
    };
  };
}
