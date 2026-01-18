{ pkgs, osConfig, ... }:
let
  secrets = osConfig.sops.secrets;

  domain = "0x7c00.org";
  mail_domain = "mail.0x7c00.org";

  mkDomainAccount =
    {
      user,
      realName,
      passwordPath,
      primary ? false,
    }:
    {
      address = "${user}@${domain}";
      userName = "${user}@${domain}";
      realName = realName;
      primary = primary;

      passwordCommand = "${pkgs.coreutils}/bin/cat ${passwordPath}";

      imapnotify = {
        enable = true;
        boxes = [ "INBOX" ];
        onNotify = ''
          OUTPUT=$(${pkgs.isync}/bin/mbsync ${user}@${domain} 2>&1)
          case "$OUTPUT" in
            *"Near: +0"*)
              ;;
            *"Near: +"*)
              ${pkgs.libnotify}/bin/notify-send 'New mail arrived' '${user}@${domain}'
              ;;
          esac
        '';
      };

      imap.host = mail_domain;
      imap.port = 993;
      smtp.host = mail_domain;
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
  accounts.email = {
    accounts = {
      "postmaster@${domain}" = mkDomainAccount {
        user = "postmaster";
        realName = "Postmaster";
        passwordPath = secrets.postmaster_password.path;
      };

      "abuse@${domain}" = mkDomainAccount {
        user = "abuse";
        realName = "Abuse Report";
        passwordPath = secrets.abuse_password.path;
      };

      "dmarc-report@${domain}" = mkDomainAccount {
        user = "dmarc-report";
        realName = "DMARC Processor";
        passwordPath = secrets.dmarc-report_password.path;
      };

      "mbr@${domain}" = mkDomainAccount {
        user = "mbr";
        realName = "MBR";
        passwordPath = secrets.mbr_password.path;
        primary = true;
      };
      "dae@${domain}" = mkDomainAccount {
        user = "dae";
        realName = "Da E";
        passwordPath = secrets.dae_password.path;
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
      set browser_sort = "unsorted"
      set mail_check_stats = yes
      set mail_check_stats_interval =30
    '';
  };

  programs.msmtp.enable = true;
  programs.mbsync.enable = true;
}
