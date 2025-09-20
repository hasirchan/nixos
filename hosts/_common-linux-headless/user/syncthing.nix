{ config, lib, pkgs, ... } : let
  userName = config.home.username;
in {
  
  home.activation.ensureSyncthingDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p /home/${userName}/Syncthing/share
  '';

  services.syncthing = {
    enable = true;
    # tray.enable = true;
    settings = {
      devices = {
        "K40S" = {
          id = "UZWLYHL-S2NGEDS-CHJKX5Z-YYWSB2E-P4NXZV7-2OKDIGJ-RJH4EHN-H4KFNQR";
        };
      };

      folders = {
        "share" = {
          path = "/home/${userName}/Syncthing/share";
          devices = [
            "K40S"
          ];
        };
      };
    };
  };
}
