{ config, lib, pkgs, ... }:
{

  networking.firewall = lib.mkIf config.networking.firewall.enable {
    trustedInterfaces = [ "Meta" ];
    checkReversePath = false;
  };

  services.mihomo = {
    enable = true;
    tunMode = true;
    configFile = toString ./mihomo.yaml;
  };
}
