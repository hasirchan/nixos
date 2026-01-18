{ hostName, ... }:
{
  imports = [
    ./${hostName}
  ];
  home-manager.users.saya = {
    imports = [
      ./home.nix
    ];
  };
}
