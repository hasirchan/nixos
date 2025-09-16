{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_common-linux-labtop/user
    ../../_common-linux-labtop/user/graphical-env/sway
    ../../_common-linux-labtop/user/pkgs/texlive.nix
    ../../_common-linux-labtop/user/pkgs/anki.nix
    ../../_common-linux-labtop/user/pkgs/aseprite.nix
  ];

  home.packages = with pkgs; [
    vim
  ];
}
