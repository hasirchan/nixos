{ config, lib, pkgs, ... }:

{
  
  imports = [
    ./mihomo
  ];

  services.openssh.enable = true;
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
}
