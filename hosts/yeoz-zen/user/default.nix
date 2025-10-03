{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_headful/user
    ../../_headful/user/graphical-env/sway
    ../../_headful/user/pkgs/texlive.nix
    ../../_headful/user/pkgs/default.nix
    ../../_headful/user/pkgs/aseprite.nix

    ./sway.nix
    ./waybar.nix
  ];

  services.mySyncthing.enable = true;
  services.syncthing.settings = {
    devices."yeoz-nano" = {
      id = "MB75EHH-7OE4HVL-B7EXFLI-ADWIZJW-26RHW3C-XSKVOKL-QXE5IEK-WLB6VAF"; 
    };
    folders."share".devices = [
      "yeoz-nano"
    ];
    folders."screenshots".devices = [
      "yeoz-nano"
    ];
    folders."pixiv".devices = [
      "yeoz-nano"
    ];
  };
}
