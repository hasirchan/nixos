{ config, ... }:
let
  domain = "0x7c00.org";
  mailDomain = "mail.0x7c00.org";
in
{

  networking.firewall.allowedTCPPorts = [
    143
    993
  ];
  sops.secrets = {
    dovecot-users = {
      sopsFile = ./secrets.yaml;
    };
  };
  users.users.vmail = {
    home = "/var/vmail";
    createHome = true;
    isSystemUser = true;
    group = "vmail";
    uid = 5000;
  };
  users.groups.vmail.gid = 5000;

  services.dovecot2 = {
    enable = true;

    enableImap = true;
    enablePop3 = false;
    enableLmtp = true;
    enablePAM = false;
    enableDHE = true;

    sslServerCert = "/var/lib/acme/${domain}/fullchain.pem";
    sslServerKey = "/var/lib/acme/${domain}/key.pem";

    mailLocation = "maildir:/var/vmail/%d/%n/Maildir";

    mailUser = "vmail";
    mailGroup = "vmail";

    mailboxes = {
      Drafts = {
        auto = "subscribe";
        specialUse = "Drafts";
      };
      Sent = {
        auto = "subscribe";
        specialUse = "Sent";
      };
      Trash = {
        auto = "subscribe";
        specialUse = "Trash";
        autoexpunge = "30d";
      };
      Junk = {
        auto = "subscribe";
        specialUse = "Junk";
        autoexpunge = "60d";
      };
      Archive = {
        auto = "subscribe";
        specialUse = "Archive";
      };
    };
    extraConfig = ''
      service imap-login {
        inet_listener imap {
          port = 143
        }
        inet_listener imaps {
          port = 993
          ssl = yes
        }
        
        process_min_avail = 4
        service_count = 1
        process_limit = 512
      }

      service auth {
        unix_listener auth-userdb {
          mode = 0640
          user = vmail
        }

        unix_listener /var/lib/postfix/queue/private/auth {
          mode = 0660
          user = postfix
          group = postfix
        }
      }

      service lmtp {
        unix_listener /var/lib/postfix/queue/private/dovecot-lmtp {
          mode = 0600
          user = postfix
          group = postfix
        }
      }

      passdb {
        driver = passwd-file
        args = scheme=CRYPT username_format=%u ${config.sops.secrets.dovecot-users.path}
      }

      userdb {
        driver = passwd-file
        args = username_format=%u ${config.sops.secrets.dovecot-users.path}
      }

      disable_plaintext_auth=yes
      auth_mechanisms = plain
      ssl_min_protocol = TLSv1.2
      ssl_cipher_list = EECDH+AESGCM:EDH+AESGCM
      ssl_prefer_server_ciphers = yes
      ssl=required

      log_path = syslog
      syslog_facility = mail
      auth_verbose = no
      auth_debug = no
      mail_debug = no
      verbose_ssl = no

      mail_prefetch_count = 20
      mail_cache_fields = flags
      mailbox_list_index = yes

      mail_privileged_group = vmail
      first_valid_uid = 5000
      last_valid_uid = 5000

      protocol imap {
        mail_max_userip_connections = 20
        imap_idle_notify_interval = 2 mins
      }

      protocol lmtp {
        postmaster_address=postmaster@${domain}
        hostname=${mailDomain}
      }
    '';
  };
}
