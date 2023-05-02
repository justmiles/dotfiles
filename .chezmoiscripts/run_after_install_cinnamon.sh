#!/bin/bash

# dconf dump /org/cinnamon/desktop/keybindings/ > ~/.config/cinnamon-desktop-keybindings.dconf

dconf load /org/cinnamon/desktop/keybindings/ < ~/.config/cinnamon-desktop-keybindings.dconf