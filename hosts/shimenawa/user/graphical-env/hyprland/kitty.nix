{ ... }:
{
  programs.kitty = {
    enable = true;
    extraConfig = ''
      background_opacity 0.8
    '';
  };
}
