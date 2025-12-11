{ config, pkgs, ... }:

let
  tex = (pkgs.texliveSmall.withPackages (
    ps: with ps; [
      xecjk
      enumitem
      titlesec
    ]
  ));
in
{
  home.packages = with pkgs; [
    tex
  ];
}
