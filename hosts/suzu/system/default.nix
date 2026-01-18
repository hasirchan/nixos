{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../shimenawa/system
    ../../torii/system/proxy/client
    ../../shimenawa/system/graphical-env/hyprland
  ];
}
