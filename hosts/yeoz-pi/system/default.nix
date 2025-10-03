{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../_headful/system
    ../../_headful/system/graphical-env/sway
  ];

  networking.hostName = "yeoz-pi"; 
}

