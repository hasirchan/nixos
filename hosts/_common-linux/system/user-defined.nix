{ config, lib, pkgs, ... }:

{
  users.users.saya = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
}
