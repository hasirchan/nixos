{ config, lib, pkgs, ... }:

let
  kmonad-swap-ctrl-caps-for-usb-kbd = pkgs.stdenv.mkDerivation rec {
    name = "kmonad-swap-ctrl-caps-for-usb-kbd.sh";
    src = ./bin/kmonad-swap-ctrl-caps-for-usb-kbd.sh;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${src} $out/bin/kmonad-swap-ctrl-caps-for-usb-kbd.sh \
        --set PATH "${lib.makeBinPath [ pkgs.bash pkgs.inotify-tools pkgs.gettext pkgs.coreutils ]}"
      chmod +x $out/bin/kmonad-swap-ctrl-caps-for-usb-kbd.sh
    '';
    dontUnpack = true;
  };
in
{
  systemd.services.kmonad-swap-ctrl-caps = {
    description = "KMonad USB Keyboard Ctrl-Caps Swap Monitor";
    wantedBy = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "simple";
      ExecStart = "${kmonad-swap-ctrl-caps-for-usb-kbd}/bin/kmonad-swap-ctrl-caps-for-usb-kbd.sh";
      Restart = "always";
      RestartSec = "5";
      User = "root";
    };
  };
}
