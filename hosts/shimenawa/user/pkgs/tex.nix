{ pkgs, ... }:
let
  tex = (
    pkgs.texliveSmall.withPackages (
      ps: with ps; [
        xecjk
        enumitem
        titlesec
        chktex
      ]
    )
  );
in
{
  home.packages = with pkgs; [
    tex
    tex-fmt
  ];
}
