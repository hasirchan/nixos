{ config, lib, pkgs, ... }:

let
  secrets = config.sops.secrets;
  
  mkDomainAccount = { user, realName, passwordPath, primary ? false }: {
    address = "${user}@0x7c00.org";
    userName = "${user}@0x7c00.org";
    realName = realName;
    primary = primary;
    
    passwordCommand = "${pkgs.coreutils}/bin/cat ${passwordPath}";

    imapnotify = {
      enable = true;
      boxes = [ "INBOX" ];
      onNotify = "${pkgs.isync}/bin/mbsync ${user}";
    };

    imap.host = "mail.0c7c00.org"; 
    imap.port = 993;
    smtp.host = "mail.0c7c00.org";
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
        { name = "${user}/Inbox"; mailbox = "Inbox"; }
        { name = "  ↳ Sent"; mailbox = "Sent"; }
        { name = "  ↳ Drafts"; mailbox = "Drafts"; }
        { name = "  ↳ Trash"; mailbox = "Trash"; }
        { name = "  ↳ Junk"; mailbox = "Junk"; }
        { name = "  ↳ Archive"; mailbox = "Archive"; }
      ];
    };
  };
in
{
  sops.secrets = {
    "postmaster_password" = { sopsFile = ./secrets.yaml; };
    "abuse_password"      = { sopsFile = ./secrets.yaml; };
    "dmarc-report_password"      = { sopsFile = ./secrets.yaml; };
    "main_username"       = { sopsFile = ./secrets.yaml; };
    "main_password"       = { sopsFile = ./secrets.yaml; };
  };

  accounts.email = {
    accounts = {
      postmaster = mkDomainAccount {
        user = "postmaster";
        realName = "Postmaster";
        passwordPath = secrets.postmaster_password.path;
      };
      abuse = mkDomainAccount {
        user = "abuse";
        realName = "Abuse Report";
        passwordPath = secrets.abuse_password.path;
      };
      dmarc-report = mkDomainAccount {
        user = "dmarc-report";
        realName = "DMARC Processor";
        passwordPath = secrets.dmarc-report_password.path;
      };
      mbr = mkDomainAccount {
        user = secrets.main_username.path; 
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
