alias top='gotop'
alias ls="ls --color=auto"
alias ll="ls -al"
alias l="ls -lart"
alias performance_mode='echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias powersave_mode='echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias cpu_frequency_watch='watch -n.5 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias chezmoi-public='chezmoi --source ~/.config/chezmoi-public --cache ~/.cache/chezmoi-public --refresh-externals'
alias chezmoi-public-cd='cd $(chezmoi-public source-path)'
alias chezmoi-cd='cd $(chezmoi source-path)'

password() {
  LEN=$1
  pwgen -1csnyr '$#{}[]<>;(),\\`*'"'"'\"' ${LEN:=25}
}

slack-kde-login() {
  while sleep .1; do ps aux | grep "kde-open5 slack://" | grep -v grep | awk '{print $12}' | while read link; do slack -s --enable-crashpad "$link"; done ; done
}

port(){
  shuf -i 2000-65000 -n 1
}

transfer() (if [ $# -eq 0 ]; then printf "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>\n">&2; return 1; fi; file_name=$(basename "$1"); if [ -t 0 ]; then file="$1"; if [ ! -e "$file" ]; then echo "$file: No such file or directory">&2; return 1; fi; if [ -d "$file" ]; then cd "$file" || return 1; file_name="$file_name.zip"; set -- zip -r -q - .; else set -- cat "$file"; fi; else set -- cat; fi; url=$("$@" | curl --silent --show-error --progress-bar --upload-file "-" "https://transfer.justmiles.io/$file_name"); echo "$url"; )


