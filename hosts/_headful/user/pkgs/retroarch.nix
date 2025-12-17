{ config, lib, pkgs, ... }:
{
  programs.retroarch = {
    enable = true;
    cores = {
      mesen.enable = true;
      mesen-s.enable = true;
    };
  };
}
