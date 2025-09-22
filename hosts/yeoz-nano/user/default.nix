{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_common-linux-labtop/user
    ../../_common-linux-labtop/user/graphical-env/sway
    ../../_common-linux-labtop/user/pkgs/texlive.nix
    ../../_common-linux-labtop/user/pkgs/anki.nix
    ../../_common-linux-labtop/user/pkgs/aseprite.nix
  ];

  services.syncthing.settings = {
    devices."yeoz-zen" = {
      id = "3ZNFOFZ-SUTO3XO-EFIDA5P-4FQ36UP-I26CARI-WDMXJBE-BCTH7WU-C5QGMQK"; 
    };
    folders."share".devices = [
      "yeoz-zen"
    ];
    folders."screenshots".devices = [
      "yeoz-zen"
    ];
    folders."pixiv".devices = [
      "yeoz-zen"
    ];
  };
}
