{ config, lib, pkgs, ... } :
{
  imports = [
    ./fonts.nix
    ./pkgs.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./kmonad.nix
  ];
}
