## weather <state> - defaults to nashville
function weather {
  [ -n $1 ] && state=$1 || state=nashville
  curl http://wttr.in/$state 
}