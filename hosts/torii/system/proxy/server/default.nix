{ config, pkgs, ... }:

{
  sops.secrets."sing-box-config" = {
    sopsFile = ./sing-box.json;
    format = "json";
    key = "";
  };

  services.sing-box = {
    enable = true;
  };

  systemd.services.sing-box = {
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.sing-box}/bin/sing-box -D /var/lib/sing-box -c ${config.sops.secrets."sing-box-config".path} run"
      ];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 443 ]; 
    allowedUDPPorts = [ 443 46721 ];
  };
}
