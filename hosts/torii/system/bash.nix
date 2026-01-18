{ ... }:
{
  programs.bash = {
    enable = true;
    blesh.enable = true;
    promptInit = ''
      if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        GIT_PROMPT="\$(
          GIT_PS1_SHOWUNTRACKEDFILES=1 \
          GIT_PS1_SHOWDIRTYSTATE=1 \
          GIT_PS1_SHOWSTASHSTATE=1 \
          GIT_PS1_SHOWUPSTREAM=auto \
          GIT_PS1_SHOWCONFLICTSTATE=yes \
          GIT_PS1_DESCRIBE_STYLE=default \
          GIT_PS1_SHOWCOLORHINTS=1 \
          __git_ps1 '(%s) '
        )"
        
        if [ -n "$INSIDE_EMACS" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1="\n\[\e[36m\]\w\[\e[m\] $GIT_PROMPT\\$ "
        else
          PS1="\n\[\e]0;\u@\h: \w\a\]\[\e[36m\]\w\[\e[m\] $GIT_PROMPT\\$ "
        fi
        
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    '';
  };
}
