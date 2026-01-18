{ config, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../torii/system
    ../../torii/system/email-server
    ../../torii/system/proxy/server
  ];

  services.openssh = lib.mkIf config.services.openssh.enable {
    ports = [ 37645 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };
  users.users.saya.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8cBAzRC+fsArWjP0eM8n73dCGAUYgSXIHoTdR7Mqs/ saya@gohei"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8cBAzRC+fsArWjP0eM8n73dCGAUYgSXIHoTdR7Mqs/ saya@gohei"
  ];
}
