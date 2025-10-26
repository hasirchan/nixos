# Generally there packages require a graphical environment so they are optional.
{ config, lib, pkgs, ... } :
{
  imports = [
    ./nvchad.nix
    ./firefox.nix
  ];
  home.packages = with pkgs; [
    vlc
    nerd-fonts.meslo-lg
    adminer
  ];
}
