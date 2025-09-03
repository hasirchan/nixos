{ config, lib, pkgs, ... } : let
  wlKbptrActiveWin = pkgs.stdenv.mkDerivation rec {
    name = "wl-kbptr-sway-active-win";

    src = pkgs.fetchFromGitHub {
      owner = "moverest";
      repo = "wl-kbptr";
      rev = "main";
      sha256 = "sha256-UEVPeqD1Oj3cK2Hq2eLpGy6Jdjd9i0tQNXdiDWAUIM0=";
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
in {
  imports = [
    ./swayidle.nix
    ./wofi.nix

    ./waybar
    #./swaybar
    ./mako.nix
  ];

  home.packages = with pkgs; [
    wl-kbptr
    wlKbptrActiveWin
    adwaita-icon-theme
    calcurse
    #papirus-icon-theme
  ];

  programs.nnn = {
    enable = true;
  };

  services.gnome-keyring.enable = true;  

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "wofi --show drun";
      defaultWorkspace = "workspace number 1";
      input = {
        "type:touchpad" = {
          #tap = "enabled";
          events = "disabled";
        };
      };

      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 8.0;
        style = "Bold Semi-Condensed";
      };

      output = {
        "*" = {
          bg = "/home/saya/Pictures/background/desktop.png fill";
        };
      };

      window = {
        border = 1;
        hideEdgeBorders = "none";
        titlebar = false;
      };
      
      colors = {
        # 全局背景色，与 waybar 背景一致
        background = "#282a36";
        
        # 聚焦窗口 - 使用紫色边框突出显示
        focused = {
          background = "#282a36";
          border = "#bd93f9";
          childBorder = "#bd93f9";
          indicator = "#bd93f9";
          text = "#f8f8f2";  # 白色文字，确保可读性
        };
        
        # 非活跃但在聚焦工作区的窗口 - 较暗的紫色
        focusedInactive = {
          background = "#282a36";
          border = "#6272a4";  # 暗紫色边框
          childBorder = "#6272a4";
          indicator = "#6272a4";
          text = "#f8f8f2";
        };
        
        # 非聚焦窗口 - 更加低调的颜色
        unfocused = {
          background = "#282a36";
          border = "#44475a";  # 深灰色边框
          childBorder = "#44475a";
          indicator = "#44475a";
          text = "#6272a4";  # 暗紫色文字
        };
        
        # 紧急状态窗口 - 使用红色警告
        urgent = {
          background = "#282a36";
          border = "#ff5555";  # 红色边框
          childBorder = "#ff5555";
          indicator = "#ff5555";
          text = "#f8f8f2";
        };
        
        # 占位符窗口
        placeholder = {
          background = "#282a36";
          border = "#44475a";
          childBorder = "#44475a";
          indicator = "#44475a";
          text = "#6272a4";
        };
      };
    };
    
    checkConfig = false;

    extraConfig = let
      mod = config.wayland.windowManager.sway.config.modifier;
    in ''
      bindsym Print exec ${pkgs.grim}/bin/grim - | ${pkgs.coreutils}/bin/tee ~/Pictures/Screenshots/$(${pkgs.coreutils}/bin/date +'%Y-%m-%d_%H-%M-%S').png | ${pkgs.wl-clipboard}/bin/wl-copy
      bindsym Shift+Print exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.coreutils}/bin/tee ~/Pictures/Screenshots/$(${pkgs.coreutils}/bin/date +'%Y-%m-%d_%H-%M-%S').png | ${pkgs.wl-clipboard}/bin/wl-copy

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

        # Middle button
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
  };
}
