{ config, lib, ... }:
{
  sops.secrets."mihomo.yaml" = {
    sopsFile = ./mihomo.yaml;
    format = "yaml";
    key = ""; # DO NOT TOUCH THIS.
  };
  networking.firewall = lib.mkIf config.networking.firewall.enable {
    trustedInterfaces = [ "Meta" ];
    checkReversePath = "loose";
  };
  services.mihomo = {
    enable = true;
    tunMode = true;
    configFile = config.sops.secrets."mihomo.yaml".path;
  };
}
