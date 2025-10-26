{ config, lib, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    blesh.enable = true;
    promptInit = ''

      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        PS1="\n\[\e[36m\]\w\[\e[m\] \$(
          GIT_PS1_SHOWUNTRACKEDFILES=1 \
          GIT_PS1_SHOWDIRTYSTATE=1 \
          GIT_PS1_SHOWSTASHSTATE=1 \
          GIT_PS1_SHOWUPSTREAM=auto \
          GIT_PS1_SHOWCONFLICTSTATE=yes \
          GIT_PS1_DESCRIBE_STYLE=default \
          GIT_PS1_SHOWCOLORHINTS=1 \
          __git_ps1 '(%s)'
        ) \\$ "
      fi
    '';
  };
}
