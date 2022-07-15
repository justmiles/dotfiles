# alias execute terraform.sh wrapper in current directory
alias t="./terraform.sh"

_t() {
  WORKSPACE_DIR=$(ls | grep environments)
  if [ ! ${WORKSPACE_DIR} ]; then
    WORKSPACE_DIR=$(ls | grep workspaces)
  fi
  local cur prev
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD - 1]}
  case ${COMP_CWORD} in
  1)
    WORDS="$(ls $(pwd)/${WORKSPACE_DIR})"
    COMPREPLY=($(compgen -W "$WORDS" -- "${cur}"))
    ;;
  2)
    WORDS="$(ls $(pwd)/${WORKSPACE_DIR}/${prev})"
    COMPREPLY=($(compgen -W "$WORDS" -- "${cur}"))
    ;;
  esac
}

complete -F _t t
