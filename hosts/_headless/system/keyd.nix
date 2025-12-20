{ config, lib, pkgs, ... }:

{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ]; 

        settings = {
          main = {
            m = "macro(w 50ms w 50ms j 50ms)";
          };
        };
      };
    };
  };
}
