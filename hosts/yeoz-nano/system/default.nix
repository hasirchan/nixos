{ config, lib, pkgs, ... }:

{
  imports = [
   ../../_common-linux/system
   ../../_common-linux/system/optional
   ../../_common-linux/system/optional/graphical-env/sway
  #  ../../_common-linux/system/optional/impermanence
  ];


  networking.hostName = "yeoz-nano"; 
}

