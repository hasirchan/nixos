{ config, lib, pkgs, ... } :
{
  imports = [
    ../../_common-linux-headless/system
    ./fonts.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./kmonad
    ./pkgs.nix
  ];
}
