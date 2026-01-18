{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "DejaVu Sans Mono"
          "Noto Sans Mono CJK SC"
        ];
        sansSerif = [
          "DejaVu Sans"
          "Noto Sans CJK SC"
        ];
        serif = [
          "DejaVu Serif"
          "Noto Serif CJK SC"
        ];
      };
    };
  };

  # For flatpak apps
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [
          "ro"
          "resolve-symlinks"
          "x-gvfs-hide"
        ];
      };
      aggregated = pkgs.buildEnv {
        name = "system-fonts-and-icons";
        paths = with pkgs; [
          kdePackages.breeze-icons # ?
          noto-fonts
          noto-fonts-color-emoji
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ];
        pathsToLink = [
          "/share/fonts"
          "/share/icons"
        ];
      };
    in
    {
      # Create an FHS mount to support flatpak host icons/fonts
      "/usr/share/icons" = mkRoSymBind "${aggregated}/share/icons";
      "/usr/share/fonts" = mkRoSymBind "${aggregated}/share/fonts";
    };
}
