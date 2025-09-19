{ config, lib, pkgs, ... } :
{
  imports = [
    ../../_common-linux-headless/system
    ../../_common-linux-headless/system/i2pd.nix
    ./fonts.nix
    ./pkgs.nix
    ./bluetooth.nix
    ./pipewire.nix
    ./kmonad
  ];
}
