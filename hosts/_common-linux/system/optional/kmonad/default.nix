{ config, lib, pkgs, ... } :
{
  services.kmonad = {
    enable = true;
    keyboards = {
      "laptop-internal" = {
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
        };
        config = ''
          (defsrc
            caps lctl
          )

          (deflayer base
            lctl caps
          )
        '';
      };
    };
  };
  users.users.saya.extraGroups = [ "input" "uinput" ];
  environment.systemPackages = with pkgs; [
    evtest
    kmonad
  ];
}
