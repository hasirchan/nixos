{ config, lib, pkgs, ... }:

{
  environment.persistence."/persist" = {
    directories = [
      "/var/db/sudo/lectured"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/lib/NetworkManager"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/daed"
    ];
    # files = [ "/etc/machine-id" ];
  };
}
