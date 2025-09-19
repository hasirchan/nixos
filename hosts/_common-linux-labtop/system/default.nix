{ config, lib, pkgs, ... } :
{
  imports = [
    ../../_common-linux-headless/system
    ../../_common-linux-headless/system/syncthing.nix
    ./fonts.nix
    ./pkgs.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./kmonad
  ];
}
