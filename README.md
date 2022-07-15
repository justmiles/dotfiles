# justmiles dotfiles

This is how I bootstrap my machines

## Usage

1. Install `chezmoi`
2. Initialize this repository with `chezmoi`.

    ```bash
    alias chezmoi-public='chezmoi --source ~/.config/chezmoi-public --cache ~/.cache/chezmoi-public' git@github.com:justmiles/dotfiles.git
    ```

2. Add the following to your .zshrc

    ```bash
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit

    for f in $(find ~/.bashrc.d -type f | sort -r ); do
      source $f
        if [ "$?" -gt "0" ]; then
          echo "[$f] could not load - exit code $?"
        fi
    done
    ```

