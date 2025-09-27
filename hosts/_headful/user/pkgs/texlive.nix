{ config, lib, pkgs, ... } :
{
  home.packages = with pkgs; [
    (pkgs.texlive.combine {
      inherit (pkgs.texlive) scheme-full;
    })
  ];
}
