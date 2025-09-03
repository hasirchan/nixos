{ config, lib, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "hasir";
    userEmail = "hasirchan@outlook.com";
  };
}
