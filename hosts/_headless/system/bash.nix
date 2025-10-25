{ config, lib, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    blesh.enable = true;
    promptInit = ''

      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        PS1="\n\[\033[32m\]\w\[\033[33m\]\$(GIT_PS1_SHOWUNTRACKEDFILES=1 GIT_PS1_SHOWDIRTYSTATE=1 __git_ps1)\[\033[00m\] \\$ "
      fi
    '';
  };
}
