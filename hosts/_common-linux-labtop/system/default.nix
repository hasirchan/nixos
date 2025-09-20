{ config, lib, pkgs, ... } :
{
  imports = [
    ../../_common-linux-headless/system
    ./fonts.nix
    ./pkgs.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./kmonad
  ];
}
