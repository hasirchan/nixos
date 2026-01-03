{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      Gereral = {
        Experimental = true;
      };
    };
  };
}
