{ config, lib, pkgs, ... } :
{
  imports = [
    ./git.nix
    ./neovim.nix
  ];
}
