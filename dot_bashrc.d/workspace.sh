_setWorkspace() {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  WORDS="$(ls ~/.workspaces | sed 's/.sh$//g' | grep -v default)"
  case "$cur" in
    *)
      COMPREPLY=($(compgen -W "$WORDS" -- "$cur"))
      ;;
  esac
}

function setWorkspace() {
  export WORKSPACE=$@
  for i in $@; do source ~/.workspaces/$i.sh; done
  # xdotool set_desktop ${WORKSPACE_ID:=0}
}

complete -F _setWorkspace setWorkspace

_moveToCurrentWorkspace() {
  local cur
  COMPREPLY=()
  cur=${COMP_WORDS[COMP_CWORD]}
  WORDS="$(wmctrl -l | awk '{$1=$2=$3=""; print $0}' | sed 's/^\ *//')"
  case "$cur" in
    *)
      IFS=$'\n' COMPREPLY=($(compgen -W "$WORDS" -- "$cur"))
      ;;
  esac
}

function moveToCurrentWorkspace() {
  ID=$(wmctrl -l | grep -i "$1" | awk '{print $1}')
  CURRENT=$(wmctrl -d | grep '*' | awk '{print $1}')
  wmctrl -i -r "$ID" -t "$CURRENT"
}

complete -F _moveToCurrentWorkspace moveToCurrentWorkspace
