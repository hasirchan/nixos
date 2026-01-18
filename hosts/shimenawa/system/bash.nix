{ config, lib, ... }:
{
  programs.bash.interactiveShellInit = lib.mkIf config.programs.bash.enable (
    lib.mkAfter ''
      [[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh"
      if [[ "$TERM" == "xterm-kitty" ]] && ! command -v icat &> /dev/null; then
          alias icat="kitty +kitten icat"
      fi
    ''
  );
}
