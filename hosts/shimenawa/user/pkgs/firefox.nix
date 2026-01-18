{ pkgs, inputs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
        asbplayer
        violentmonkey
        videospeed
      ];
      settings = {
        "extensions.autoDisableScopes" = 0;
        "extensions.enabledScopes" = 15;
        "browser.fullscreen.autohide" = false;
      };
    };
  };
}
