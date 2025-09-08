{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_common-linux/user
    ../../_common-linux/user/optional
    ../../_common-linux/user/optional/graphical-env/sway
    ./sway.nix
    ../../_common-linux/user/optional/pkgs/texlive.nix
  ];

  home.packages = with pkgs; [
    vim
  ];
}
