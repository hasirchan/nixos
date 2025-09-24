{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_common-linux-labtop/system
    ../../_common-linux-labtop/system/graphical-env/sway
    ./overlays
  ];

  networking.hostName = "yeoz-nano"; 
}

