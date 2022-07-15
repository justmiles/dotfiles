alias top='gotop -c solarized -m'
alias ls="ls --color=auto"
alias ll="ls -al"
alias l="ls -lart"
alias performance_mode='echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias powersave_mode='echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor'
alias cpu_frequency_watch='watch -n.5 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'
alias chezmoi-public='chezmoi --source ~/.config/chezmoi-public --cache ~/.cache/chezmoi-public --refresh-externals' 

password() {
  LEN=$1
  pwgen -1csnyr '$#{}[]<>;(),\\`*'"'"'\"' ${LEN:=25}
}
