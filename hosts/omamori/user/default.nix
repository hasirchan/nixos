{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../shimenawa/user
    ../../shimenawa/user/graphical-env/hyprland
  ];
}
