{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_headful/system
    ../../_headful/system/graphical-env/sway
  ];

  networking.hostName = "yeoz-pi"; 
}

