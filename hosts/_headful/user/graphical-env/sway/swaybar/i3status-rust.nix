{ config, lib, pkgs, ... } :

{
  programs.i3status-rust = {
    enable = true;
    bars = {
      status = {
        /*
        settings = {
          theme = {
            theme = "plain";
            overrides = {
              good_bg = "#50FA7B";
              good_fg = "#000000";
              info_bg = "#8be9fd";
              info_fg = "#000000";
              warning_bg = "#f1fa8c";
              warning_fg = "#000000";
              critical_bg = "#ff5555";
              critical_fg = "#ffffff";
            };
          };
        };
        */
        settings = {
          theme = {
            theme = "plain";
            overrides = {
              idle_bg = "none";
              good_bg = "none";
              warning_bg = "none";
              critical_bg = "none";
              info_bg = "none";
              alternating_tint_bg = "none";
              separator_bg = "none";
              separator = "┃";
            };
          };
          icons = {
            icons = "material-nf";
            overrides = {
              backlight = [ "BRT" ];
              bat_charging = "CHG";
              bat_not_available = "NO BAT";
              bat = [ "EMPTY" "BAT" "FULL" ];
              volume_muted = "SPK MUT";
              volume = [ "SPK" ];
              microphone_muted = "MIC MUT";
              microphone = [ "MIC" ];
            };
          };
        };
        blocks = [

          {
            block = "sound";
            format = "{$icon}{ $volume|}";
            format_alt = "{$output_name}{ $volume|}";
            driver = "auto";
            step_width = 5;
          }

          {
            block = "backlight";
            format = "{$icon}{ $brightness|}";
            missing_format = "";
            step_width = 5;
            minimum = 1;
            cycle = [1 10 20 30 40 50 60 70 80 90 100];
          }

          {
            block = "net";
            device = "^w.*";
            format = "{$device}{ $ip| N/A}";
            format_alt = "{$device}{ $ip| N/A}{ $ipv6| N/A}";
            inactive_format = "{$device}";
            missing_format = "";
            interval = 1;
          }

          {
            block = "net";
            device = "^e.*";
            format = "{$device}{ $ip| N/A}";
            format_alt = "{$device}{ $ip| N/A}{ $ipv6| N/A}";
            inactive_format = "{$device}";
            missing_format = "";
            interval = 1;
          }

          {
            block = "battery";
            format = "{$icon}{ $percentage|}";
            full_format = "{$icon}";
            empty_format = "{$icon}";
            missing_format = "";
            interval = 1;
          }

          {
            block = "time";
            format = "{$timestamp.datetime(f:'%a %d/%m/%y %H:%M:%S')}";
            interval = 1;
          }
        ];
      };
    };
  };
}

