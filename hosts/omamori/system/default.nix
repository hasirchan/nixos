{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../torii/system
    ../../torii/system/proxy/client
  ];
  boot.loader.efi.canTouchEfiVariables = false;
}
