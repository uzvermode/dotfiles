#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export PS1="\[\033[1;94m\]{\[\e[1;92m\]\W\[\e[0m\]\[\033[1;94m\]}\[\e[0m\]\[\033[0;37m\] \[\e[1;91m\]> \[\e[0m\]"
PROMPT_DIRTRIM=1
export HISTCONTROL=ignoreboth:erasedups

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ftor='find . -maxdepth 1 -name "*.torrent" -exec rm -rf {} \;'
alias psx='ps aux | grep'
#alias vim='nvim'
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi
#alias nvimconf='nvim ~/.config/nvim/init.vim'
alias sudo='sudo '
# alias mc='export DE=xfce && mc'
alias ls='ls --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias tvemu='xfreerdp -grab-keyboard /rfx /cert-ignore /t:TVEmu /size:1245x815 /v:192.168.2.100:3389'
alias winemu='xfreerdp -grab-keyboard /rfx /cert-ignore /t:Win10 /size:1366x768 /v:192.168.2.100:3391'

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# PS1='[\u@\h \W]\$ '

# ssh() {
#    tmux rename-window "$*"
#    command ssh "$@"
#    tmux setw automatic-rename
# }

mlive() {
    mpv --no-video "$1" > /dev/null 2>&1
}

padon(){
    PADID=$(xinput list | grep 'Synaptics' | awk '{print $5}' | cut -d '=' -f2-)
    xinput set-prop $PADID 177 1
    # xinput set-prop $PADID 305 1
}

padoff(){
    PADID=$(xinput list | grep 'Synaptics' | awk '{print $5}' | cut -d '=' -f2-)
    xinput set-prop $PADID 177 0
    # xinput set-prop $PADID 305 0
}

night(){
    xfconf-query -c xsettings -p /Net/ThemeName -t string -s "Matcha-dark-sea"
    xfconf-query -c xfwm4 -p /general/theme -t string -s "Matcha-dark-sea"
    echo -e "--force-dark-mode\n--enable-features=WebUIDarkMode">>$HOME/.config/chromium-flags.conf
}

day(){
    xfconf-query -c xsettings -p /Net/ThemeName -t string -s "Matcha-sea"
    xfconf-query -c xfwm4 -p /general/theme -t string -s "Matcha-sea"
    sed -i '/--force-dark-mode/d' $HOME/.config/chromium-flags.conf
    sed -i '/--enable-features=WebUIDarkMode/d' $HOME/.config/chromium-flags.conf
}

#FZF
source /usr/share/fzf/completion.bash && source /usr/share/fzf/key-bindings.bash

# Yarn
export PATH="$(yarn --offline global bin):$PATH"
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
