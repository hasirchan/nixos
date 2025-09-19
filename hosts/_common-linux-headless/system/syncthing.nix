{ config, lib, pkgs, ... } : let
  userName = "saya";
  userGroup = "users";
  hostName = config.networking.hostName;
in {

  system.activationScripts.ensureDirs = {
    text = ''
      mkdir -p /home/${userName}/Syncthing /home/${userName}/.${hostName}
      chown -R ${userName}:${userGroup} /home/${userName}/Syncthing /home/${userName}/.${hostName}
    '';
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "${userName}";
    group = "${userGroup}";
    dataDir = "/home/${userName}/Syncthing";
    overrideDevices = true;
    overrideFolders = true;

    settings = {
      folders = {
        "yeoz-zen" = {
          path = "/home/${userName}/.${hostName}";
        };
      };
    };
  };
}
