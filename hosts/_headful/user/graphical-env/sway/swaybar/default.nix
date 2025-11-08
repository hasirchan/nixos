{ config, lib, pkgs, ... } :

{
  imports = [
    ./i3status-rust.nix
  ];

  wayland.windowManager.sway.config.bars = [
    {
      id = "status";
      position = "top";
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-status.toml";
      extraConfig = ''
        icon_theme Adwaita
      '';


      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
      };
    }
  ];
}
