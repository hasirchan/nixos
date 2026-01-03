{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../torii/system
    ./fonts.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./bash.nix
    ./services.nix
    #./pkgs.nix
  ];
}
