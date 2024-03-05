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