# Generally there packages require a graphical environment so they are optional.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./firefox.nix
  ];
  home.packages = with pkgs; [
    adminer
    pdfpc
  ];
}
