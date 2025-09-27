{ config, lib, pkgs, ... }:

{
  imports = [
   ../../_headful/system
   ../../_headful/system/graphical-env/sway
   ./battery-charge-threshold.nix
   ./nvidia.nix
  ];

  networking.hostName = "yeoz-zen"; 


  environment.etc."wireplumber/wireplumber.conf.d/alsa-soft-mixer.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            device.name = "alsa_card.usb-ASUSTeK_COMPUTER_INC._C-Media_R__Audio-00"
          }
        ]
        actions = {
          update-props = {
            # Do not use the hardware mixer for volume control. It
            # will only use software volume. The mixer is still used
            # to mute unused paths based on the selected port.
            api.alsa.soft-mixer = true
          }
        }
      }
    ]
  '';
}

