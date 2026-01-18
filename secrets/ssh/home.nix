{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."default" = {
      host = "*";
      serverAliveInterval = 60;
    };
  };
}
