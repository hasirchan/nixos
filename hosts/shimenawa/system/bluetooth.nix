{ ... }:
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
