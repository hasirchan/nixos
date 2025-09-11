{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_common-linux/user
    ../../_common-linux/user/optional
    ../../_common-linux/user/optional/graphical-env/sway
    ../../_common-linux/user/optional/pkgs/texlive.nix
    ../../_common-linux/user/optional/pkgs/aseprite.nix
    ../../_common-linux/user/optional/pkgs/anki.nix
  ];

  home.packages = with pkgs; [
    vim
  ];
}
