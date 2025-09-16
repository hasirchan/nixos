
/*
Legacy. Have tried using nixpkgs for firefox in the past, but have decided to use the flatpak version. 
The fact that it's still here means that I may or may not reuse it in the future.
In order to install the extension, need to add "firefox-addons" below to inputs.
And if the module is one of home-manager's submodules, also need to make sure that home-manager's submodules can use the inputs parameter.
  firefox-addons = {
    url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    inputs.nixpkgs.follows = "nixpkgs";
  };
*/

{ config, lib, pkgs, inputs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default =  {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        asbplayer
      ];
      settings = {
        "extensions.autoDisableScopes" = 0;
        "extensions.enabledScopes" = 15;
        "browser.fullscreen.autohide" = false;
      };
    };
  };
}
