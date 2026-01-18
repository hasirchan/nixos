{ pkgs, self, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../shimenawa/system
    ../../torii/system/proxy/client
    ../../shimenawa/system/graphical-env/hyprland
    ../../shimenawa/system/obs.nix
    ../../shimenawa/system/flatpak.nix
    ./flatpak.nix
    ./battery-charge-threshold.nix
    ./nvidia.nix
    ./data.nix
    "${self}/secrets/email"
    "${self}/secrets/ssh"
  ];

  environment.systemPackages = with pkgs; [ quickemu ];

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
