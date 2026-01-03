{ config, pkgs, lib, options, self, ... }:

let
  domain = "0x7c00.org";
  mailDomain = "mail.0x7c00.org";
  adminEmail = "admin@${domain}";
in {

  sops.secrets = {
    cloudflare_dns_api_token = { sopsFile = ./secrets.yaml; };
    main_username = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
    main_password = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
    admin_password = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
    dmarc-report_password = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
    postmaster_password = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
    abuse_password = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
    domain = { sopsFile = "${self}/secrets/email.yaml"; };
    mail_domain = { sopsFile = "${self}/secrets/email.yaml"; };
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
      "dmarc-report@${domain}"
      "${config.sops.secrets.main_username.path}"
    ];
    ensureCredentials = {
      "${adminEmail}" = {
        passwordFile = config.sops.secrets.admin_password.path;
      };
      
      "postmaster@${domain}" = {
        passwordFile = config.sops.secrets.postmaster_password.path;
      };
      
      "dmarc-report@${domain}" = {
        passwordFile = config.sops.secrets.dmarc-report_password.path;
      };
      
      "abuse@${domain}" = {
        passwordFile = config.sops.secrets.abuse_password.path;
      };
      "${config.sops.secrets.main_username.path}" = {
        passwordFile = config.sops.secrets.main_password.path;
      };
    };

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
        environmentFile = config.sops.secrets.cloudflare_dns_api_token.path;
      };
    };
  };
}
