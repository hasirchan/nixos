{ config, lib, pkgs, ... } : let
  i3status-reminder = pkgs.stdenv.mkDerivation rec {
    name = "reminder.sh";
    src = ./bin/reminder.sh;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${src} wrapped-reminder.sh \
        --set PATH "${lib.makeBinPath [ pkgs.systemd pkgs.dbus pkgs.procps pkgs.bash pkgs.gnugrep pkgs.coreutils ]}"
      cp wrapped-reminder.sh $out/bin/reminder.sh
      chmod +x $out/bin/reminder.sh
    '';
    dontUnpack = true;
  };
in {

  systemd.user.services = {
    i3status-reminder = {
      Unit = {
        Description = "Remind i3status";
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
        ExecStart = "${i3status-reminder}/bin/reminder.sh";
      };

    };
  };
}
