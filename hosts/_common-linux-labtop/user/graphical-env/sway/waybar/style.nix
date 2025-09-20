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
      background-color: rgba(40, 42, 54, 0.85);
      border: 1px solid rgba(189, 147, 249, 0.6);
      border-radius: 6px;
      margin: 3px 10px 0px 10px;
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

  general = ''
    {
      color: #f8f8f2;
      background-color: rgba(68, 71, 90, 0.4);
      border-radius: 4px;
      margin: 1px;
      padding: 0px 5px;
    }
  '';

  great = ''
    {
      background-color: rgba(80, 250, 123, 0.3);
      color: #50fa7b;
    }
  '';

  good = ''
    {
      background-color: rgba(139, 233, 253, 0.3);
      color: #8be9fd;
    }
  '';

  normal = ''
    {
      color: #6272a4;
      background-color: rgba(98, 114, 164, 0.2);
    }
  '';

  warning = ''
    {
      color: #f1fa8c;
      background-color: rgba(241, 250, 140, 0.2);
    }
  '';

  critical = ''
    {
      color: #ff5555;
      background-color: rgba(255, 85, 85, 0.2);
    }
  '';

  inconspicuous = ''
    {
      color: #44475a;
      background-color: rgba(68, 71, 90, 0.1);
      opacity: 0.5;
    }
  '';

  conspicuous = ''
    mode {
      background-color: rgba(255, 0, 255, 0.2);
      color: #ff00ff;
    }
  '';

  clockCss = ''
    {
      font-weight: 500;
      padding: 0px 6px;
    }
  '';

  workspacesButton = ''
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
  '';

  workspacesAndMode = ''
    #workspaces,
    #mode {
      background-color: rgba(68, 71, 90, 0.4);
      border-radius: 4px;
      padding: 0px 3px;
      margin: 1px;
    }
  '';
in {


  programs.waybar.style = 
      base 
    + tray 
    + workspacesButton 
    + workspacesAndMode 
    + "#mode" 
    + conspicuous 

    + "#memory, #cpu, #clock, #wireplumber, #custom-battery-status, #idle_inhibitor, #network, #bluetooth, #backlight, #tray" 
    + general 

    + "#memory.warning, #cpu.warning, #custom-battery-status.warning, #bluetooth.no-controller" 
    + warning 

    + "#memory.critical, #cpu.critical, #custom-battery-status.critical" 
    + critical 

    + "#custom-battery-status.charging, #network.wifi, #network.ethernet, #bluetooth.connected" 
    + great 

    + "#custom-battery-status.good, #idle_inhibitor.activated" 
    + good 

    + "#wireplumber.muted, #network.disconnected, #bluetooth.off, #idle_inhibitor.deactivated"
    + normal 

    + "#bluetooth.disabled" 
    + inconspicuous;
}
