{ osConfig, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        host = "github.com";
        hostname = "github.com";
        user = "saya";
        port = 22;
        identityFile = osConfig.sops.secrets.github_key.path;
      };
      "ofuda" = {
        host = "ofuda";
        hostname = "mail.0x7c00.org";
        user = "saya";
        port = 37645;
        identityFile = osConfig.sops.secrets.ofuda_key.path;
      };
    };
  };
}
