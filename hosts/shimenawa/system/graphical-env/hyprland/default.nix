{
  config,
  lib,
  pkgs,
  ...
}:
{

  programs.bash.interactiveShellInit = lib.mkIf config.programs.bash.enable (
    lib.mkAfter ''
      if [[ "$(tty)" = "/dev/tty1" ]] && uwsm check may-start && uwsm select; then
        exec uwsm start default
      fi
    ''
  );

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kitty
    rofi
    libnotify
    grimblast
    grim
    slurp
    wl-clipboard
    wiremix
    bluetuith
    playerctl
    brightnessctl
    mpv
  ];

  security.polkit.enable = true;
  security.pam.services.hyprlock = { };
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
