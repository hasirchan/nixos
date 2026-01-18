{ pkgs, ... }:
{
  imports = [
    ./firefox.nix
  ];
  home.packages = with pkgs; [
    adminer
    pdfpc
  ];
}
