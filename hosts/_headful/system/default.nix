{ config, lib, pkgs, ... } :
{
  imports = [
    ../../_headless/system
    ./fonts.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./kmonad
    ./pkgs.nix
  ];
}
