{ config, pkgs, ... }:
let
  domain = "105386.xyz";
in
{
  sops.secrets = {
    sing-box-config = {
      sopsFile = ./sing-box.json;
      format = "json";
      key = "";
    };

    cloudflare_dns_api_token_for_xyz = {
      sopsFile = ./secrets.yaml;
    };
  };
  services.sing-box = {
    enable = true;
  };

  security.acme = {
    acceptTerms = true;
    certs."${domain}" = {
      email = "admin@${domain}";
      dnsProvider = "cloudflare";
      postRun = "systemctl --no-block restart sing-box.service";
      environmentFile = config.sops.secrets.cloudflare_dns_api_token_for_xyz.path;
    };
  };

  systemd.services.sing-box = {
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.sing-box}/bin/sing-box -D /var/lib/sing-box -c ${config.sops.secrets.sing-box-config.path} run"
      ];
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 8443 ];
    allowedUDPPorts = [
      443
      8443
    ];
  };
}
