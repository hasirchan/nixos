{ config, lib, pkgs, ... }:

{
  services.swayidle = let
    # Lock command
    lock = "${pkgs.swaylock}/bin/swaylock -f -i /home/saya/Pictures/background/lockscreen.png";
    # Sway
    display = status: "${pkgs.sway}/bin/swaymsg 'output * power ${status}'";
  in {
    enable = true;
    timeouts = [
      {
        timeout = 25; # in seconds
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds' -t 5000";
      }
      {
        timeout = 30;
        command = display "off";
        resumeCommand = display "on";
      }
      {
        timeout = 35;
        command = lock;
      }
      /*{
        timeout = 40;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }*/
    ];
    events = [
      /*{
        event = "before-sleep";
        # adding duplicated entries for the same event may not work
        command = (display "off") + "; " + lock;
      }
      {
        event = "after-resume";
        command = display "on";
      }*/
      {
        event = "lock";
        command = (display "off") + "; " + lock;
      }
      {
        event = "unlock";
        command = display "on";
      }
    ];
  };
}
