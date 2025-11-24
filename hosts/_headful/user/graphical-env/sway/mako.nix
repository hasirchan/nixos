{ config, lib, pkgs, ... } :

{
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrains Mono 11";
    };
  };
}
