{ pkgs, ... }:
{
  programs.eww = {
    enable = true;
    configDir = toString ./config;
  };
  home.packages = with pkgs; [ hyprland-workspaces ];
}
