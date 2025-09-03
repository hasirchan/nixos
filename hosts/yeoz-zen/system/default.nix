{ config, lib, pkgs, ... }:

{
  imports = [
   ../../_common-linux/system
   ../../_common-linux/system/optional
   ../../_common-linux/system/optional/graphical-env/sway
   ./battery-charge-threshold.nix
  ];


  networking.hostName = "yeoz-zen"; 
  boot.blacklistedKernelModules = ["nouveau" "nvidia"];
}

