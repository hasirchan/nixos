{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_headful/system
    ../../_headful/system/graphical-env/sway
    ./overlays
  ];

  networking.hostName = "yeoz-nano"; 
}

