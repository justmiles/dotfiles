#!/bin/bash

# Only set crontab if crontab exists
type -p crontab>/dev/null || exit 0

# * * * * * "command to be executed"
# - - - - -
# | | | | |
# | | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
# | | | ------- Month (1 - 12)
# | | --------- Day of month (1 - 31)
# | ----------- Hour (0 - 23)
# ------------- Minute (0 - 59)

function setCrontab() {
  CRON=$1
  CMD=$(echo "$CRON" | cut -d " " -f 6-)

  # if the job doesn't exist, consider adding it
  crontab -l | grep -F "$CRON" >/dev/null 2>&1 || (

    # if command already exists (but different schedule), remove it
    crontab -l | grep -F "$CMD" >/dev/null 2>&1 && (
      crontab -l | grep -vF "$CMD" | crontab -
    )

    # add the job
    crontab -l | { cat; echo "$CRON"; } | crontab -
  )
}

# Update the 2fa crontab
setCrontab "30 10 * * * ~/.local/bin/2fa-cache"
