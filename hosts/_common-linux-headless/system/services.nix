{ config, lib, pkgs, ... }:

{
  services.openssh.enable = true;
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
  services.daed = {
    enable = true;
  };
  #services.flatpak.enable = true;
}
