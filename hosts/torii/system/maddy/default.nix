{ config, pkgs, lib, options, ... }:

let
  domain = "0x7c00.org";
  mailDomain = "mail.0x7c00.org";
  adminEmail = "admin@0x7c00.org";
in {

  sops.secrets = {
    "cloudflare_dns_api_token" = { sopsFile = ./secrets.yaml; };
  };

  networking.firewall.allowedTCPPorts = [ 25 143 465 587 993 ];
  services.maddy = {
    enable = true;
    primaryDomain = domain;
    openFirewall = false;
    
    ensureAccounts = [
      adminEmail
      "postmaster@${domain}"
      "abuse@${domain}"
    ];

    tls = {
      loader = "file";
      certificates = [{
        certPath = "/var/lib/acme/${domain}/fullchain.pem";
        keyPath = "/var/lib/acme/${domain}/key.pem";
      }];
    };

    config = let
      defaultConfig = options.services.maddy.config.default;
    in builtins.replaceStrings [
      "imap tcp://0.0.0.0:143"
      "submission tcp://0.0.0.0:587"
      "dmarc yes"
    ] [
      "imap tls://0.0.0.0:993 tcp://0.0.0.0:143"
      "submission tls://0.0.0.0:465 tcp://0.0.0.0:587"
      "dmarc yes\n    max_message_size 64M"
    ] defaultConfig;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = adminEmail;
    certs = {
      "${domain}" = {
        domain = mailDomain;
        group = "maddy";
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets."cloudflare_dns_api_token".path;
      };
    };
  };
}
