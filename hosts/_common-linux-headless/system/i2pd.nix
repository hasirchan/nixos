{ config, lib, pkgs, ... } : let 
  i2cpPort = 7856;
in {
  services.i2pd = {
    enable = true;
    enableIPv6 = true;
    address = "127.0.0.1";
    proto = {
      http.enable = true;
      socksProxy.enable = true;
      httpProxy.enable = true;
      sam.enable = true;
      i2cp = {
        enable = true;
        address = "127.0.0.1";
        port = i2cpPort; 
      };
    };
  };
}
