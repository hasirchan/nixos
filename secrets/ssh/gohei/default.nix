{ ... }:
{
  sops.secrets = {
    github_key = {
      sopsFile = ./gohei.yaml;
      owner = "saya";
      mode = "0400";
    };
    ofuda_key = {
      sopsFile = ./gohei.yaml;
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
