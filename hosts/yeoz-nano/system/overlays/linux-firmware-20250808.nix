{ config, pkgs, lib, pkgs-df3b69d, ... } :
{
  nixpkgs.overlays = [
    (final: prev: {
      linux-firmware = pkgs-df3b69d.linux-firmware;
    })
  ];
}
