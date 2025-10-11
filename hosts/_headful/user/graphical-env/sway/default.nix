{ config, lib, pkgs, osConfig, ... } :
{
  imports = [
    ./swayidle.nix
    ./wofi.nix

    ./waybar
    #./swaybar
    ./mako.nix
    ./sway-extra-config.nix
  ];

  xdg = {
    enable = true;
    autostart.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = null;
    };
  };

  home.activation = {
    ensureDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ~/Pictures/Screenshots ~/Pictures/Backgrounds
    '';
  };

  home.packages = with pkgs; [
    wl-kbptr
    adwaita-icon-theme
    calcurse
  ];

  programs.nnn = {
    enable = true;
  };

  services.gnome-keyring.enable = true;  

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = osConfig.programs.sway.package;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      menu = "wofi --show drun -W 16% -H 18%";
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
          bg = "/home/saya/Pictures/Backgrounds/desktop.png fill";
        };
      };

      window = {
        border = 1;
        hideEdgeBorders = "none";
        titlebar = false;
      };
      
      colors = {
        background = "#282a36";
        
        focused = {
          background = "#282a36";
          border = "#bd93f9";
          childBorder = "#bd93f9";
          indicator = "#bd93f9";
          text = "#f8f8f2"; 
        };
        
        focusedInactive = {
          background = "#282a36";
          border = "#6272a4";
          childBorder = "#6272a4";
          indicator = "#6272a4";
          text = "#f8f8f2";
        };
        
        unfocused = {
          background = "#282a36";
          border = "#44475a";  
          childBorder = "#44475a";
          indicator = "#44475a";
          text = "#6272a4"; 
        };
        
        urgent = {
          background = "#282a36";
          border = "#ff5555";  
          childBorder = "#ff5555";
          indicator = "#ff5555";
          text = "#f8f8f2";
        };
        
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

  };
}
