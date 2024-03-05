#!/bin/bash

# Overcast Tab completion
_overcast_completions() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  COMPREPLY=($(compgen -W "`overcast completions`" -- "$cur"))
  return 0
}
complete -F _overcast_completions overcast
