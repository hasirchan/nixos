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
        blocks = [

          {
            block = "sound";
            format = " VOL {$volume} ";
            format_alt = " $output_name {$volume} ";
            driver = "auto";
            step_width = 5;
          }

          {
            block = "backlight";
            format = "BRT $brightness";
            missing_format = "";
            step_width = 5;
            minimum = 1;
          }

          {
            block = "net";
            device = "^w.*";
            format = " $device $ip ";
            format_alt = " $device $ip $ipv6 ";
            inactive_format = " $device ";
            missing_format = "";
            interval = 1;
          }

          {
            block = "net";
            device = "^e.*";
            format = " $device $ip ";
            format_alt = " $device $ip $ipv6 ";
            inactive_format = " $device ";
            missing_format = "";
            interval = 1;
          }

          {
            block = "battery";
            format = " BAT $percentage ";
            full_format = " FULL ";
            charging_format = " CHG $percentage ";
            empty_format = " EMPTY ";
            missing_format = "";
            interval = 1;
          }

          {
            block = "time";
            format = " $timestamp.datetime(f:'%a %d/%m/%y %H:%M:%S') ";
            interval = 1;
          }
        ];
      };
    };
  };
}

