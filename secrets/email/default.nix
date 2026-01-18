{ ... }:
{
  sops.secrets = {
    abuse_password = {
      sopsFile = ./secrets.yaml;
      owner = "saya";
      mode = "0400";
    };
    postmaster_password = {
      sopsFile = ./secrets.yaml;
      owner = "saya";
      mode = "0400";
    };
    dmarc-report_password = {
      sopsFile = ./secrets.yaml;
      owner = "saya";
      mode = "0400";
    };
    mbr_password = {
      sopsFile = ./secrets.yaml;
      owner = "saya";
      mode = "0400";
    };
    dae_password = {
      sopsFile = ./secrets.yaml;
      owner = "saya";
      mode = "0400";
    };
  };
  home-manager.users.saya = {
    imports = [
      ./home.nix
    ];
  };
}
