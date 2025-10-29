{ config, lib, pkgs, ... }:
{
  imports = [
    ../../_headful/system
    ../../_headful/system/graphical-env/sway
    ./hardware-configuration.nix
  ];

  networking.hostName = "yeoz-classic";

  services.daed.enable = false;
}
