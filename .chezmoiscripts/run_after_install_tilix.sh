#!/bin/bash

# Only set dconf if dconf exists
type -p dconf>/dev/null || exit 0

# dconf dump /com/gexperts/Tilix/ > ~/.config/tilix.dconf

dconf load /com/gexperts/Tilix/ < ~/.config/tilix.dconf