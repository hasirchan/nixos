{ config, lib, pkgs, ... }:

{
  imports = [
    ../../_headful/user
    ../../_headful/user/graphical-env/sway
    ../../_headful/user/pkgs/texlive.nix
    ../../_headful/user/pkgs/anki.nix
    ../../_headful/user/pkgs/vscode.nix
    #../../_headful/user/pkgs/aseprite.nix
  ];

  services.mySyncthing.enable = true;

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
