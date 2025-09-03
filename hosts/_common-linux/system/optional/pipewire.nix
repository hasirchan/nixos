{ config, lib, pkgs, ... } :
{
  imports = [
    ./fonts.nix
    ./pkgs.nix
    ./kmonad.nix
  ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;    
  };
}
