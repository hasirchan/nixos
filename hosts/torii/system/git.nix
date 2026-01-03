{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    prompt.enable = true;
  };
}
