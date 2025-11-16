{ config, lib, pkgs, ... }:
{

  networking.firewall = lib.mkIf config.networking.firewall.enable {
    trustedInterfaces = [ "Meta" ];
    checkReversePath = "loose";
  };

  services.mihomo = {
    enable = true;
    tunMode = true;
    configFile = toString ./mihomo.yaml;
  };
}
