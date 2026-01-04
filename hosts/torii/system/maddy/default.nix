{ config, pkgs, lib, options, self, ... }:

let
  domain = "0x7c00.org";
  mail_domain = "mail.0x7c00.org";
  adminEmail = "admin@${domain}";
in {

  sops.secrets = {
    cloudflare_dns_api_token = { sopsFile = ./secrets.yaml; };
    resend_api_token = { sopsFile = ./secrets.yaml; owner = "maddy"; };
    mbr_password = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
    admin_password = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
    dmarc-report_password = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
    postmaster_password = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
    abuse_password = { sopsFile = "${self}/secrets/email.yaml"; owner = "maddy"; };
  };

  networking.firewall.allowedTCPPorts = [ 25 143 465 587 993 ];
  services.maddy = {
    enable = true;
    primaryDomain = domain;
    openFirewall = false;
    hostname = domain;
    ensureAccounts = [
      adminEmail
      "postmaster@${domain}"
      "abuse@${domain}"
      "dmarc-report@${domain}"
      "mbr@${domain}"
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
      "mbr@${domain}" = {
        passwordFile = config.sops.secrets.mbr_password.path;
      };
    };

    tls = {
      loader = "file";
      certificates = [{
        certPath = "/var/lib/acme/${domain}/fullchain.pem";
        keyPath = "/var/lib/acme/${domain}/key.pem";
      }];
    };
    secrets = [
      config.sops.secrets.resend_api_token.path
    ];
    config = let
      defaultConfig = options.services.maddy.config.default;
      resendBlock = ''
        target.smtp resend_relay {
            targets tcp://smtp.resend.com:587
            auth plain "resend" "{env:RESEND_API_TOKEN}"
            starttls yes
        }

        msgpipeline outbound_delivery {
            deliver_to &resend_relay
        }
      '';
      oldOutboundBlock = ''
    target.remote outbound_delivery {
      limits {
        destination rate 20 1s
        destination concurrency 10
      }
      mx_auth {
        dane
        mtasts {
          cache fs
          fs_dir mtasts_cache/
        }
        local_policy {
            min_tls_level encrypted
            min_mx_level none
        }
      }
    }'';

    in builtins.replaceStrings [
      "imap tcp://0.0.0.0:143"
      "submission tcp://0.0.0.0:587"
      "dmarc yes"
      oldOutboundBlock
    ] [
      "imap tls://0.0.0.0:993 tcp://0.0.0.0:143"
      "submission tls://0.0.0.0:465 tcp://0.0.0.0:587"
      "dmarc yes\n    max_message_size 64M"
      resendBlock
    ] defaultConfig;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = adminEmail;
    certs = {
      "${domain}" = {
        domain = mail_domain;
        group = "maddy";
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets.cloudflare_dns_api_token.path;
      };
    };
  };
}
