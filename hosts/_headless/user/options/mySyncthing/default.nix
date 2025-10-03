{ config, lib, pkgs, ... }@args: let
  cfg = config.services.mySyncthing;
in {
  options.services.mySyncthing = {
    enable = lib.mkEnableOption "Enable syncthing service and apply my syncthing config";
  };
  config = lib.mkIf cfg.enable (import ./syncthing.nix args);
}


