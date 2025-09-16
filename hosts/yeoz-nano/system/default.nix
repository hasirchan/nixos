{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_common-linux-labtop/system
    ../../_common-linux-labtop/graphical-env/sway
  ];

  networking.hostName = "yeoz-nano"; 
}

