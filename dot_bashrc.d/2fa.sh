#!/bin/bash

_2fa() {
  
  [ -f ~/.cache/2fa.cache ] || exit 1

  local cur
  local IFS=$'\n'
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  echo $cur
  WORDS="$(cat ~/.cache/2fa.cache 2>/dev/null)"
  case "$cur" in
  *)
    COMPREPLY=($(compgen -W "$WORDS" -- "$cur"))
    ;;
  esac

}

# Complete 2fa
complete -F _2fa 2fa
