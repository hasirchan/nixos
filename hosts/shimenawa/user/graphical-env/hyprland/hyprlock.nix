{ ... }:
{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          # path = "~/Pictures/wallpaper.png";
          blur_passes = 3;
          blur_size = 8;
          contrast = 1.0;
          brightness = 0.5;
          vibrancy = 0.2;
          vibrancy_darkness = 0.2;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "400, 90";
          outline_thickness = 2;

          dots_size = 0.25;
          dots_spacing = 0.35;
          dots_center = true;
          dots_rounding = -1;

          outer_color = "rgba(242, 243, 244, 0.3)";
          inner_color = "rgba(0, 0, 0, 0.6)";
          font_color = "rgb(242, 243, 244)";

          fade_on_empty = true;
          fade_timeout = 1000;

          placeholder_text = "<i>I am a input filed.</i>";

          position = "0, -20%";
          halign = "center";
          valign = "center";

          shadow_passes = 2;
          shadow_size = 3;
          shadow_color = "rgba(0, 0, 0, 0.5)";
        }
      ];

      label = [
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%H:%M")"'';
          color = "rgba(242, 243, 244, 0.95)";
          font_size = 120;
          font_family = "Sans";

          position = "0, 25%";
          halign = "center";
          valign = "center";

          shadow_passes = 2;
          shadow_size = 3;
          shadow_color = "rgba(0, 0, 0, 0.5)";
        }

        {
          monitor = "";
          text = ''cmd[update:3600000] echo "$(date +"%A, %B %d")"'';
          color = "rgba(242, 243, 244, 0.8)";
          font_size = 28;
          font_family = "Sans";

          position = "0, 15%";
          halign = "center";
          valign = "center";

          shadow_passes = 2;
          shadow_size = 3;
          shadow_color = "rgba(0, 0, 0, 0.5)";
        }

        {
          monitor = "";
          text = "$USER";
          color = "rgba(242, 243, 244, 0.8)";
          font_size = 20;
          font_family = "Sans";

          position = "0, -30%";
          halign = "center";
          valign = "center";

          shadow_passes = 2;
          shadow_size = 3;
          shadow_color = "rgba(0, 0, 0, 0.5)";
        }

        {
          monitor = "";
          text = ''cmd[update:1000] if [ "$ATTEMPTS" != "0" ]; then echo "$ATTEMPTS"; fi'';
          color = "rgba(255, 100, 100, 0.9)";
          font_size = 16;
          font_family = "Sans";

          position = "0, -35%";
          halign = "center";
          valign = "center";

          shadow_passes = 2;
          shadow_size = 3;
          shadow_color = "rgba(0, 0, 0, 0.5)";
        }
      ];
    };
  };
}
