{ config, lib, pkgs, ... }:

{
  imports = [
   ../../_common-linux/system
   ../../_common-linux/system/optional
   ../../_common-linux/system/optional/graphical-env/sway
   ./battery-charge-threshold.nix
  ];


  networking.hostName = "yeoz-zen"; 
  boot.blacklistedKernelModules = ["nouveau" "nvidia"];

  services.pipewire.wireplumber.extraConfig = {
    "monitor.alsa.rules" = {
      matches = [
        {
          "device.name" = "alsa_card.usb-ASUSTeK_COMPUTER_INC._C-Media_R__Audio-00";
        }
      ];
      actions = [
        {
          update-props = {
            "api.alsa.soft.mixer" = true;
          };
        }
      ];
    };
  };
}

