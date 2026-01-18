{
  config,
  lib,
  pkgs,
  hostName,
  ...
}:
{
  imports = [
    ./kitty.nix
    ./hyprlock.nix
    ./eww
    #./waybar.nix
  ];

  xdg = {
    enable = true;
    autostart.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = null;
      publicShare = null;
      templates = null;
    };
    systemDirs.data = [
      "/var/lib/flatpak/exports/share"
      "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
    ];
  };

  home.activation = {
    ensureDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ${config.home.homeDirectory}/Pictures/Screenshots ${config.home.homeDirectory}/Pictures/Backgrounds
    '';
  };

  home.packages = with pkgs; [
    wl-kbptr
    wlrctl
  ];

  services.hyprpolkitagent.enable = true;
  services.mako = {
    enable = true;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "${config.home.homeDirectory}/Pictures/Backgrounds/desktop.png";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 20;
          on-timeout = "notify-send 'Locking in 10 seconds' -t 5000";
        }

        {
          timeout = 30;
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 40;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      xwayland = {
        force_zero_scaling = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        sensitivity = 0;

        kb_options = "ctrl:nocaps";
      };

      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";
      /*
            workspace = [
              "1, default:true"
            ];
      */
      /*
            general = {
              gaps_in = 1;
              gaps_out = 0;
            };
      */
      exec-once = [
        "eww open bar"
      ];

      bind = [
        ", Print, exec, grimblast copysave output ${config.home.homeDirectory}/Pictures/Screenshots/${hostName}_$(date +'%Y-%m-%d_%H-%M-%S').png"
        "SHIFT, Print, exec, grimblast copysave area ${config.home.homeDirectory}/Pictures/Screenshots/${hostName}_$(date +'%Y-%m-%d_%H-%M-%S').png"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
    };

    extraConfig = ''
      #windowrulev2 = opacity 0.4 0.4, class:^(com.github.IsmaelMartinez.teams_for_linux)$

      bind = CONTROL,SPACE,submap,root
      submap = root

      bind = ,F,fullscreen,0
      bind = ,RETURN,exec,$terminal
      bind = ,E,exec,$fileManager
      bind = ,Q,killactive
      bind = ,M,exit
      bind = ,V,togglefloating
      bind = ,R,exec,$menu
      bind = ,P,pseudo
      bind = ,I,togglesplit

      bind = ,left,movefocus,l
      bind = ,right,movefocus,r
      bind = ,up,movefocus,u
      bind = ,down,movefocus,d
      bind = ,H,movefocus,l 
      bind = ,L,movefocus,r
      bind = ,K,movefocus,u
      bind = ,J,movefocus,d

      bind = SHIFT,left,movewindow,l
      bind = SHIFT,right,movewindow,r
      bind = SHIFT,up,movewindow,u
      bind = SHIFT,down,movewindow,d
      bind = SHIFT,H,movewindow,l
      bind = SHIFT,L,movewindow,r
      bind = SHIFT,K,movewindow,u
      bind = SHIFT,J,movewindow,d

      bind = ,1,workspace,1
      bind = ,2,workspace,2
      bind = ,3,workspace,3
      bind = ,4,workspace,4
      bind = ,5,workspace,5
      bind = ,6,workspace,6
      bind = ,7,workspace,7
      bind = ,8,workspace,8
      bind = ,9,workspace,9
      bind = ,0,workspace,10

      bind = SHIFT,1,movetoworkspace,1
      bind = SHIFT,2,movetoworkspace,2
      bind = SHIFT,3,movetoworkspace,3
      bind = SHIFT,4,movetoworkspace,4
      bind = SHIFT,5,movetoworkspace,5
      bind = SHIFT,6,movetoworkspace,6
      bind = SHIFT,7,movetoworkspace,7
      bind = SHIFT,8,movetoworkspace,8
      bind = SHIFT,9,movetoworkspace,9	class: pdfpc
      bind = SHIFT,0,movetoworkspace,10

      bind = ,S,togglespecialworkspace,S
      bind = SHIFT,S,movetoworkspace,special:S
      bind = ,T,togglespecialworkspace,T
      bind = SHIFT,T,movetoworkspace,special:T

      bind = ,mouse_down,workspace,e+1
      bind = ,mouse_up,workspace,e-1

      bind = , escape, submap, reset
      bindrt = ,SPACE,submap,reset 

      submap = reset

      submap=cursor

      bind=,a,exec,hyprctl dispatch submap reset && wl-kbptr && hyprctl dispatch submap cursor

      binde=,j,exec,wlrctl pointer move 0 10
      binde=,k,exec,wlrctl pointer move 0 -10
      binde=,l,exec,wlrctl pointer move 10 0
      binde=,h,exec,wlrctl pointer move -10 0

      bind=,s,exec,wlrctl pointer click left
      bind=,d,exec,wlrctl pointer click middle
      bind=,f,exec,wlrctl pointer click right

      binde=,e,exec,wlrctl pointer scroll 10 0
      binde=,r,exec,wlrctl pointer scroll -10 0

      binde=,t,exec,wlrctl pointer scroll 0 -10
      binde=,g,exec,wlrctl pointer scroll 0 10

      bind=,escape,exec,hyprctl keyword cursor:inactive_timeout 3; hyprctl keyword cursor:hide_on_key_press true; hyprctl dispatch submap reset 

      submap = reset

      bind=$mainMod,G,exec,wl-kbptr
      bind=$mainMod,B,exec,hyprctl keyword cursor:inactive_timeout 0; hyprctl keyword cursor:hide_on_key_press false; hyprctl dispatch submap cursor
      bind=$mainMod,N,exec,wl-kbptr -o modes=floating,click -o mode_floating.source=detect
      bind=$mainMod,L,exec,loginctl lock-session

    '';
  };
}
