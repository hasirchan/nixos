{ pkgs, ... }:
{

  system.activationScripts.createFlatpakMountPoints = {
    deps = [ "etc" ];
    text = ''
      ${pkgs.coreutils}/bin/mkdir -p /home/saya/.saya
    '';
  };

  fileSystems."/home/saya/.saya" = {
    device = "/dev/disk/by-uuid/d8aaee03-036d-4c1a-a553-c67b0324ff71";
    fsType = "btrfs";
    options = [
      "subvol=data/@saya"
      "compress=zstd"
      "noatime"
    ];
  };
  systemd.services = {
    "set-data-permissions" = {
      description = "Set Permissions for .saya";
      wantedBy = [ "multi-user.target" ];
      after = [
        "home-saya-.saya.mount"
      ];

      requires = [
        "home-saya-.saya.mount"
      ];

      serviceConfig = {
        ExecStart = "${pkgs.coreutils}/bin/chown -R saya:users /home/saya/.saya";
        Type = "oneshot";
      };
    };
  };
}
