{ osConfig, ... }:
{
  programs.ssh = {
    matchBlocks."github.com" = {
      host = "github.com";
      hostname = "github.com";
      user = "saya";
      port = 22;
      identityFile = osConfig.sops.secrets.github_key.path;
    };
    matchBlocks."ofuda" = {
      host = "ofuda";
      hostname = "mail.0x7c00.org";
      user = "saya";
      port = 37645;
      identityFile = osConfig.sops.secrets.ofuda_key.path;
    };
  };
}
