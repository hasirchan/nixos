{ config, lib, pkgs, ... } :
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # 若要远程SSH，否则留空
  };
}
