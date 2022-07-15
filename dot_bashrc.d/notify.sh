#!/bin/bash
function notify() {
  echo "Waiting for pid $1 to exit"
  while :; do
    if ! ps $1 >/dev/null; then
      echo "Stopped"
      aws sns publish --phone-number "+16152430637" --message "PID $1 has finished running\!"
      break
    fi
    sleep 1
  done
}

function monitor() {
  CMD=$@

  echo $CMD
  INVOCATIONS=0
  while true; do
    let "INVOCATIONS=INVOCATIONS+1"
    RESULTS=$(bash -c "$CMD")
    CODE=$?
    if [ $CODE -eq 0 ]; then
      echo "Command Successful: $CMD"
      aws sns publish \
        --phone-number "+16152430637" \
        --message "Command Finished: $CMD"
      break
    fi
    echo -ne "\rInvocations: $INVOCATIONS\t Exit Code: $CODE\t Results: $RESULTS"
    sleep 5
  done
}
