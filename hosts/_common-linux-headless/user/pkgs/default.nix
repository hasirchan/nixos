{ config, lib, pkgs, ... } :
{
  imports = [
    ./helix.nix
    ./git.nix
    ./zsh
  ];
}
