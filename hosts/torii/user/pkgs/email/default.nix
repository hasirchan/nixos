{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  secrets = config.sops.secrets;
  domain = "${config.sops.secrets.domain.path}";
  mailDomain = "${config.sops.screts.mail_domain.path}";

  mkDomainAccount =
    {
      user,
      realName,
      passwordPath,
      primary ? false,
    }:
    {
      address = "${user}";
      userName = "${user}";
      realName = realName;
      primary = primary;

      passwordCommand = "${pkgs.coreutils}/bin/cat ${passwordPath}";

      imapnotify = {
        enable = true;
        boxes = [ "INBOX" ];
        onNotify = "${pkgs.isync}/bin/mbsync ${user}";
      };

      imap.host = mailDomain;
      imap.port = 993;
      smtp.host = mailDomain;
      smtp.port = 465;

      msmtp.enable = true;
      mbsync = {
        enable = true;
        create = "maildir";
      };

      neomutt = {
        enable = true;
        showDefaultMailbox = false;
        extraMailboxes = [
          {
            name = "${user}/Inbox";
            mailbox = "Inbox";
          }
          {
            name = "  ↳ Sent";
            mailbox = "Sent";
          }
          {
            name = "  ↳ Drafts";
            mailbox = "Drafts";
          }
          {
            name = "  ↳ Trash";
            mailbox = "Trash";
          }
          {
            name = "  ↳ Junk";
            mailbox = "Junk";
          }
          {
            name = "  ↳ Archive";
            mailbox = "Archive";
          }
        ];
      };
    };
in
{
  sops.secrets = {
    postmaster_password = {
      sopsFile = "${self}/secrets/email.yaml";
    };
    abuse_password = {
      sopsFile = "${self}/secrets/email.yaml";
    };
    dmarc-report_password = {
      sopsFile = "${self}/secrets/email.yaml";
    };
    main_username = {
      sopsFile = "${self}/secrets/email.yaml";
    };
    main_password = {
      sopsFile = "${self}/secrets/email.yaml";
    };
    admin_password = {
      sopsFile = "${self}/secrets/email.yaml";
    };
    domain = {
      sopsFile = "${self}/secrets/email.yaml";
    };
    mail_domain = {
      sopsFile = "${self}/secrets/email.yaml";
    };
  };

  accounts.email = {
    accounts = {
      "postmaster@${domain}" = mkDomainAccount {
        user = "postmaster@${domain}";
        realName = "Postmaster";
        passwordPath = secrets.postmaster_password.path;
      };

      "admin@${domain}" = mkDomainAccount {
        user = "admin@${domain}";
        realName = "Administrator";
        passwordPath = secrets.admin_password.path;
      };
      "abuse@${domain}" = mkDomainAccount {
        user = "abuse@${domain}";
        realName = "Abuse Report";
        passwordPath = secrets.abuse_password.path;
      };

      "dmarc-report@${domain}" = mkDomainAccount {
        user = "dmarc-report@${domain}";
        realName = "DMARC Processor";
        passwordPath = secrets.dmarc-report_password.path;
      };

      "${config.sops.secrets.main_username.path}" = mkDomainAccount {
        user = "${config.sops.secrets.main_username.path}";
        realName = "MBR";
        passwordPath = secrets.main_password.path;
        primary = true;
      };
    };
  };

  services.mbsync.enable = true;
  services.imapnotify.enable = true;

  programs.neomutt = {
    enable = true;
    vimKeys = true;
    sidebar.enable = true;
    extraConfig = ''
            set mail_check_stats = yes
            set mail_check_stats_interval = 60
            set browser_sort = 'unsorted'
          '';
  };

  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
}
