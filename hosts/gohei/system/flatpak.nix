{ pkgs, ... }:
{

  system.activationScripts.createFlatpakMountPoints = {
    deps = [ "etc" ];
    text = ''
      ${pkgs.coreutils}/bin/mkdir -p /home/saya/.var
      ${pkgs.coreutils}/bin/mkdir -p /home/saya/.local/share/flatpak
      ${pkgs.coreutils}/bin/mkdir -p /var/lib/flatpak
    '';
  };

  fileSystems."/var/lib/flatpak" = {
    device = "/dev/disk/by-uuid/d8aaee03-036d-4c1a-a553-c67b0324ff71";
    fsType = "btrfs";
    options = [
      "subvol=flatpak/@root-var-lib-flatpak"
      "compress=zstd"
      "noatime"
    ];
  };
  fileSystems."/home/saya/.var" = {
    device = "/dev/disk/by-uuid/d8aaee03-036d-4c1a-a553-c67b0324ff71";
    fsType = "btrfs";
    options = [
      "subvol=flatpak/@home-saya-dotvar"
      "compress=zstd"
      "noatime"
    ];
  };
  fileSystems."/home/saya/.local/share/flatpak" = {
    device = "/dev/disk/by-uuid/d8aaee03-036d-4c1a-a553-c67b0324ff71";
    fsType = "btrfs";
    options = [
      "subvol=flatpak/@home-saya-dotlocal-share-flatpak"
      "compress=zstd"
      "noatime"
    ];
  };
  systemd.services = {
    "set-flatpak-permissions" = {
      description = "Set Flatpak Permissions for .var and .local/share/flatpak";
      wantedBy = [ "multi-user.target" ];
      after = [
        "var-lib-flatpak.mount"
        "home-saya-.var.mount"
        "home-saya-.local-share-flatpak.mount"
      ];

      requires = [
        "home-saya-.var.mount"
        "home-saya-.local-share-flatpak.mount"
      ];

      serviceConfig = {
        ExecStart = "${pkgs.coreutils}/bin/chown -R saya:users /home/saya/.var /home/saya/.local/share/flatpak";
        Type = "oneshot";
      };
    };
  };
}
