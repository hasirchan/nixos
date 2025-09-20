{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_common-linux-labtop/user
    ../../_common-linux-labtop/user/graphical-env/sway
    ../../_common-linux-labtop/user/pkgs/texlive.nix
    ../../_common-linux-labtop/user/pkgs/default.nix
    ../../_common-linux-labtop/user/pkgs/aseprite.nix

    ./sway.nix
  ];
  
  services.syncthing = {
    settings.devices."yeoz-nano" = {
      id = "MB75EHH-7OE4HVL-B7EXFLI-ADWIZJW-26RHW3C-XSKVOKL-QXE5IEK-WLB6VAF"; 
    }
    settings.folders."share".devices = [
      "yeoz-nano"
    ];
  }
}
