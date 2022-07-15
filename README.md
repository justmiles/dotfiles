# justmiles dotfiles

This is how I bootstrap my machines

## Usage

1. Install `chezmoi`

    ```bash
    sh -c "$(curl -fsLS chezmoi.io/get)"
    ```

2. Initialize this repository with `chezmoi`.

    ```bash
    
    chezmoi --source ~/.config/chezmoi-public --cache ~/.cache/chezmoi-public --refresh-externals init --apply https://github.com/justmiles/dotfiles.git
    ```

2. Add the following to your .zshrc

    ```bash
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit

    for f in $(find ~/.bashrc.d -type f | sort -r ); do
        source $f || echo "[$f] could not load - exit code $?"
    done
    ```
