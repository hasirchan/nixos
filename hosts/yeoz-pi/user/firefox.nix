{ config, lib, pkgs, inputs, ... } : 
{
  programs.firefox.profiles.default.extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [ violentmonkey ];
}
