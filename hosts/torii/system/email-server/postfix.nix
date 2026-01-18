{ config, ... }:
let
  domain = "0x7c00.org";
  mailDomain = "mail.0x7c00.org";
in
{

  networking.firewall.allowedTCPPorts = [
    25
    587
    465
  ];
  sops.secrets = {
    cloudflare_dns_api_token_for_org = {
      sopsFile = ./secrets.yaml;
    };

    resend_password_maps = {
      sopsFile = ./secrets.yaml;
    };
  };

  security.acme = {
    acceptTerms = true;
    certs."${domain}" = {
      domain = mailDomain;
      email = "admin@${domain}";
      dnsProvider = "cloudflare";
      postRun = "systemctl --no-block restart postfix.service";
      environmentFile = config.sops.secrets.cloudflare_dns_api_token_for_org.path;
    };
  };

  services.opendkim = {
    enable = true;
    selector = "default";
    domains = domain;
    settings = {
      Umask = "007";
    };
  };

  users.users.postfix.extraGroups = [ "opendkim" ];

  services.postfix = {
    enable = true;

    settings.main = {
      myhostname = mailDomain;
      mydomain = domain;
      myorigin = domain;

      mydestination = [
        "$myhostname"
        "localhost.$mydomain"
        "localhost"
      ];

      virtual_mailbox_domains = [ domain ];
      masquerade_domains = domain;

      mynetworks_style = "host";
      mynetworks = [
        "127.0.0.0/8"
        "[::1]/128"
      ];

      message_size_limit = 52428800;

      recipient_delimiter = "+";

      relayhost = [
        "[smtp.resend.com]:587"
      ];

      strict_rfc821_envelopes = "yes";

      virtual_transport = "lmtp:unix:private/dovecot-lmtp";

      smtp_sasl_auth_enable = true;
      smtp_sasl_password_maps = "texthash:${config.sops.secrets.resend_password_maps.path}";
      smtp_sasl_security_options = "noanonymous";
      smtp_sasl_mechanism_filter = "plain,login";

      smtp_tls_security_level = "encrypt";
      smtp_tls_loglevel = 1;

      smtpd_tls_auth_only = "yes";
      smtpd_helo_required = "yes";
      smtpd_delay_reject = "yes";
      smtpd_tls_security_level = "may";
      smtpd_tls_chain_files = [
        "/var/lib/acme/${domain}/key.pem"
        "/var/lib/acme/${domain}/fullchain.pem"
      ];

      smtpd_recipient_restrictions = [
        "permit_mynetworks"
        "permit_sasl_authenticated"

        "reject_unauth_destination"
        "reject_unauth_pipelining"

        "reject_non_fqdn_sender"
        "reject_non_fqdn_recipient"

        "reject_unknown_client_hostname"
        "reject_unknown_recipient_domain"
        "reject_unknown_sender_domain"
      ];

      smtpd_tls_loglevel = 1;
      smtpd_milters = [ config.services.opendkim.socket ];
      non_smtpd_milters = [ config.services.opendkim.socket ];

      milter_default_action = "tempfail";
      milter_protocol = "6";

      smtp_connection_cache_on_demand = true;
      smtp_connection_cache_destinations = [ "$relayhost" ];

      smtp_tls_note_starttls_offer = true;
    };

    enableSmtp = true;

    enableSubmission = true;
    submissionOptions = {
      smtpd_tls_security_level = "encrypt";
      smtpd_sasl_auth_enable = "yes";
      smtpd_sasl_type = "dovecot";
      smtpd_sasl_path = "private/auth";
      smtpd_client_restrictions = "permit_sasl_authenticated,reject";
      smtpd_recipient_restrictions = "permit_sasl_authenticated,reject_unauth_destination";
      milter_macro_daemon_name = "ORIGINATING";
    };

    enableSubmissions = true;
    submissionsOptions = {
      smtpd_sasl_auth_enable = "yes";
      smtpd_sasl_type = "dovecot";
      smtpd_sasl_path = "private/auth";
      smtpd_client_restrictions = "permit_sasl_authenticated,reject";
      smtpd_recipient_restrictions = "permit_sasl_authenticated,reject_unauth_destination";
      milter_macro_daemon_name = "ORIGINATING";
    };
    virtual = ''
      admin@${domain}  postmaster@${domain}
    '';
  };
}
