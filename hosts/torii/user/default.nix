{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./pkgs
    ./options
  ];
  home = {
    stateVersion = "25.05";
    username = "saya";
    homeDirectory = "/home/saya";
  };
}
