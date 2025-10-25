{ config, lib, pkgs, ... }:

{
  users.users.saya = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
