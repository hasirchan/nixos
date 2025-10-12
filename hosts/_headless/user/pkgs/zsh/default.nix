{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  home.file = {
    ".p10k.zsh" = {
      source = builtins.toString ./p10k.zsh;
    };

    ".p10k-tty.zsh" = {
      source = builtins.toString ./p10k-tty.zsh;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.size = 10000;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };


    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      if [[ "$TERM" == "linux" || -n $SSH_CONNECTION ]]; then
        source ~/.p10k-tty.zsh
      else
        source ~/.p10k.zsh
      fi

      if command -v nix-your-shell > /dev/null; then
        nix-your-shell zsh | source /dev/stdin
      fi
    '';
  };
}
