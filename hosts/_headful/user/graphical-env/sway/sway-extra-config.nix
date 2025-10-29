{ config, lib, pkgs, osConfig, ... } : let
  wlKbptrActiveWin = pkgs.stdenv.mkDerivation rec {
    name = "wl-kbptr-sway-active-win";

    src = pkgs.fetchFromGitHub {
      owner = "moverest";
      repo = "wl-kbptr";
      rev = "main";
      sha256 = "sha256-IeyLoMdSnPN2slYUA3XU0uDxJwhWq5Dg9cNGgLOwvSQ=";
    };
    
    nativeBuildInputs = [ pkgs.makeWrapper ];    

    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${src}/helpers/wl-kbptr-sway-active-win wrapped-wl-kbptr-sway-active-win \
        --set PATH "${lib.makeBinPath [ pkgs.jq pkgs.sway pkgs.wl-kbptr ]}"
      mv wrapped-wl-kbptr-sway-active-win $out/bin/wl-kbptr-sway-active-win
      chmod +x $out/bin/wl-kbptr-sway-active-win
    '';
  };
  hostName = osConfig.networking.hostName;
  mod = config.wayland.windowManager.sway.config.modifier;
in {
  wayland.windowManager.sway.extraConfig = ''
    # For policykit agent
    exec ${pkgs.soteria}/bin/soteria

    # For screenshots

    bindsym Print exec ${pkgs.grim}/bin/grim - | ${pkgs.coreutils}/bin/tee ~/Pictures/Screenshots/${hostName}_$(${pkgs.coreutils}/bin/date +'%Y-%m-%d_%H-%M-%S').png | ${pkgs.wl-clipboard}/bin/wl-copy
    bindsym Shift+Print exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.coreutils}/bin/tee ~/Pictures/Screenshots/${hostName}_$(${pkgs.coreutils}/bin/date +'%Y-%m-%d_%H-%M-%S').png | ${pkgs.wl-clipboard}/bin/wl-copy

    # For volume control
    bindsym XF86AudioRaiseVolume exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
    bindsym XF86AudioLowerVolume exec ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
    bindsym XF86AudioMute exec ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

    # For screen backlight
    bindsym XF86MonBrightnessUp exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%
    bindsym XF86MonBrightnessDown exec ${pkgs.bash}/bin/bash -c 'current=$(${pkgs.brightnessctl}/bin/brightnessctl get); max=$(${pkgs.brightnessctl}/bin/brightnessctl max); if [ $((current * 100 / max - 5)) -lt 1 ]; then ${pkgs.brightnessctl}/bin/brightnessctl set 1%; else ${pkgs.brightnessctl}/bin/brightnessctl set 5%-; fi'

    # For keyboard backlight
    bindsym XF86KbdBrightnessUp exec ${pkgs.brightnessctl}/bin/brightnessctl -d $(ls /sys/class/leds/ | ${pkgs.coreutils}/bin/grep kbd_backlight | ${pkgs.coreutils}/bin/head -n1) set +1
    bindsym XF86KbdBrightnessDown exec ${pkgs.brightnessctl}/bin/brightnessctl -d $(ls /sys/class/leds/ | ${pkgs.coreutils}/bin/grep kbd_backlight | ${pkgs.coreutils}/bin/head -n1) set 1-

    # For lockscreen
    bindsym ${mod}+Shift+x exec "${pkgs.swaylock}/bin/swaylock -f -i /home/saya/Pictures/Backgrounds/lockscreen.png

    # For wl-kbptr
    mode Mouse {
      bindsym a mode default, exec '${wlKbptrActiveWin}/bin/wl-kbptr-sway-active-win; ${pkgs.sway}/bin/swaymsg mode Mouse'
      bindsym Shift+a mode default, exec '${pkgs.wl-kbptr}/bin/wl-kbptr; ${pkgs.sway}/bin/swaymsg mode Mouse'

      # Mouse move
      bindsym h seat seat0 cursor move -15 0
      bindsym j seat seat0 cursor move 0 15
      bindsym k seat seat0 cursor move 0 -15
      bindsym l seat seat0 cursor move 15 0

      # Left button
      bindsym s seat seat0 cursor press button1
      bindsym --release s seat seat0 cursor release button1

      # Middle buttoear

      bindsym d seat seat0 cursor press button2
      bindsym --release d seat seat0 cursor release button2

      # Right button
      bindsym f seat seat0 cursor press button3
      bindsym --release f seat seat0 cursor release button3

      bindsym Escape mode default
    }

    bindsym ${mod}+g exec ${wlKbptrActiveWin}/bin/wl-kbptr-sway-active-win -o modes=floating','click -o mode_floating.source=detect
    bindsym ${mod}+Shift+g mode Mouse
    bindsym ${mod}+Alt+g exec ${pkgs.wl-kbptr}/bin/wl-kbptr
  '';
}
