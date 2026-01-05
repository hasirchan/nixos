{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../shimenawa/system
    ../../shimenawa/system/graphical-env/hyprland
  ];
}
