{ config, lib, pkgs, ... } : let 
  base = ''
    * {
      font-family: JetBrainsMono Nerd Font;
      font-size: 12px;
      padding: 0;
      margin: 0;
      border: none;
    }
    window#waybar {
      color: #f8f8f2;
      /*
      background-color: rgba(40, 42, 54, 0.85);
      border: 1px solid rgba(189, 147, 249, 0.6);
      border-radius: 6px; 
      margin: 3px 10px 0px 10px;
      */

      background-color: transparent;
      border: none
    }
  '';

  tray = ''
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

  general = builtins.readFile ./css/general.css;
  great = builtins.readFile ./css/great.css;
  good = builtins.readFile ./css/good.css;
  normal = builtins.readFile ./css/normal.css;
  warning = builtins.readFile ./css/warning.css;
  critical = builtins.readFile ./css/critical.css;
  inconspicuous = builtins.readFile ./css/inconspicuous.css;
  conspicuous = builtins.readFile ./css/conspicuous.css;

  workspacesButton = ''
    #workspaces button {
      color: #6272a4;
      padding: 0px 5px;
      font-size: 12px;
      border-radius: 3px;
      border: 1px solid rgba(189, 147, 249, 0.6);
      background-color: transparent;
      margin-right: 1px;
      margin-left: 1px;
    }
    #workspaces button:last-child {
      margin-right: 0;
    }
    #workspaces button:first-child {
      margin-left: 0;
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
  '';

in {
  programs.waybar.style = 
      base
    + "#memory, #cpu, #clock, #wireplumber, #custom-battery-status, #idle_inhibitor, #network, #bluetooth, #backlight, #tray, #mode, #custom-menu" 
    + general 
    + tray 
    + workspacesButton 
    + "#mode, #network.linked, #bluetooth.off" 
    + conspicuous 

    + "#memory.warning, #cpu.warning, #custom-battery-status.warning, #bluetooth.no-controller" 
    + warning 

    + "#memory.critical, #cpu.critical, #custom-battery-status.critical, #workspaces button.urgent" 
    + critical 

    + "#custom-battery-status.charging, #network.wifi, #network.ethernet, #bluetooth.connected, #bluetooth.connected-battery, #workspaces button.visible" 
    + great 

    + "#custom-battery-status.good, #idle_inhibitor.activated" 
    + good 

    + "#wireplumber.muted, #network.disconnected, #bluetooth.on, #idle_inhibitor.deactivated"
    + normal 

    + "#bluetooth.disabled, #network.disabled" 
    + inconspicuous;
}
