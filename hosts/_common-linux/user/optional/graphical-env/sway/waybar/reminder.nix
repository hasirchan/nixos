{ config, lib, pkgs, ... } : let
  waybar-reminder = pkgs.stdenv.mkDerivation rec {
    name = "reminder.sh";
    src = ./bin/reminder.sh;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${src} wrapped-reminder.sh \
        --set PATH "${lib.makeBinPath [ pkgs.bash pkgs.systemd pkgs.procps pkgs.coreutils pkgs.udev ]}"
      cp wrapped-reminder.sh $out/bin/reminder.sh
      chmod +x $out/bin/reminder.sh
    '';
    dontUnpack = true;
  };
in {

  systemd.user.services = {
    waybar-reminder = {
      Unit = {
        Description = "Remind waybar";
        Wants = [ "network-online.target" ];
        After = [ "network-online.target" "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        Restart = "always";
        Restartsec = 5;
        ExecStart = "${waybar-reminder}/bin/reminder.sh";
      };

    };
  };
}