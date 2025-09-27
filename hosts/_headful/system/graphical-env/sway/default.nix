{ config, lib, pkgs, ... }:

{
  imports = [
    #./i3status-reminder.nix
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = lib.mkDefault "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway --user-menu --user-menu-min-uid 1000";
        user = "greeter";
      };
    };
  };

  programs.sway = let 
    kittyAsXterm = pkgs.stdenv.mkDerivation {
      name = "kitty-xterm";
      buildInputs = [ pkgs.kitty ];
      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/bin
        ln -s ${pkgs.kitty}/bin/kitty $out/bin/xterm
      '';
    };
  in {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      kittyAsXterm
      
      grim
      slurp
      wl-clipboard
      mako
      kitty
      wofi
      swaylock
      swayidle
      swaybg
      brightnessctl
      wiremix
      bluetuith
      soteria
    ];
  };

  services.upower.enable = true;
  environment.etc."xterm".source = "${pkgs.kitty}/bin/kitty";
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.udisks2.enable = true;
}
