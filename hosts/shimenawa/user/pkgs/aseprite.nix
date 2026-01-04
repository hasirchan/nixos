{
  config,
  lib,
  pkgs,
  pkgs-unfree,
  ...
}:
{
  home.packages = with pkgs-unfree; [
    aseprite
  ];
}
