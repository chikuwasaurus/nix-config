# editor を helix に設定
export EDITOR=hx
# zsh でターミナルの出力が改行されずに最後の行に到達したとき、末尾に記号(%や#)が表示されないようにする
# export PROMPT_EOL_MARK=''

# Disable flow control to use ctrl-s for forward search
stty -ixon

# 履歴ファイルの保存先
HISTFILE=${HOME}/.zsh_history
# メモリに保存される履歴の件数
HISTSIZE=100000
# 履歴ファイルに保存される履歴の件数
SAVEHIST=100000

# コマンド入力時に同じコマンドがあれば古いものを消す
setopt HIST_IGNORE_ALL_DUPS
# 保存時に同じコマンドがあれば古いものを消す
setopt HIST_SAVE_NO_DUPS
# セッションの終了を待たずに HISTFILE に追記
setopt INC_APPEND_HISTORY
# 先頭にスペースを付けたコマンドを履歴に保存しない
setopt HIST_IGNORE_SPACE
# 履歴に保存するとき、余分な空白を詰める
setopt HIST_REDUCE_BLANKS
# 履歴ファイルに「実行時刻」と「実行時間」も保存する
setopt EXTENDED_HISTORY
# 複数のシェルで履歴を共有
# setopt SHARE_HISTORY

# zsh で help コマンドを使えるようにする
unalias run-help 2>/dev/null
autoload -Uz run-help
alias help=run-help

# コマンドの色付けを有効にする
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# ls のエイリアス
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# rm のエイリアス
alias rm='gomi'

# Treat Nerd Font Private Use Area glyphs as printable in less.
# Without this, icons from tools like eza may disappear or break when viewed
# through less or pagers that use less, such as bat.
#
# Ranges:
#   E000-F8FF       BMP Private Use Area
#   F0000-FFFFD     Supplementary Private Use Area-A
#   100000-10FFFD   Supplementary Private Use Area-B
export LESSUTFCHARDEF='E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p'

# Show a Git-aware directory tree with Nerd Font icons and colors.
# eza disables icons/colors when piped, so force them with `always`.
alias tree='eza --tree'
alias treep='eza --tree --git --icons=always --color=always | bat'

# 使用中のポートを表示
# https://qiita.com/yokozawa/items/dbcb3b31f9308e4dcefc
alias port="lsof -i -P | grep \"LISTEN\""

# 参考 https://www.avg.com/en/signal/find-ip-address
# この mac の global ip v4 アドレス
alias ipv4="curl ifconfig.io -4"
# この mac の global ip v6 アドレス
alias ipv6="curl ifconfig.io -6"
# この mac の local ip アドレス（wi-fi 接続の場合）
alias ipl="ipconfig getifaddr en0"
# この mac の local ip アドレス（有線(wired)接続の場合）
alias iplw="ipconfig getifaddr en1"
# 「MAC アドレス」は「Media Access Control Address」の略で、ネットワーク機器に一意に割り当てられた識別子のこと。
# MAC アドレスはローカルネットワーク内でデバイスを一意に識別するためのアドレスであり、インターネットを越えて通信する際には MAC アドレスは使用されない。
# この mac の MAC アドレス (wi-fi 接続の場合)
alias mac="ifconfig en0 | grep ether | xargs"
# この mac の MAC アドレス (有線(wired)接続の場合)
alias macw="ifconfig en1 | grep ether | xargs"

# 物理 CPU コア数
alias cpup="sysctl -n hw.physicalcpu"
# 論理 CPU コア数
alias cpul="sysctl -n hw.logicalcpu"

# キーバインディング
source "$HOME/.config/zsh/keybindings.zsh"

# sheldon: zsh のプラグインマネージャ
# shell のプラグイン周りは sheldon で管理している(~/.config/sheldon/plugins.toml)。
eval "$(sheldon source)"
eval "$(starship init zsh)"
# eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(atuin init zsh)"

# fzf を Catppuccin Mocha theme にする
# https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-mocha.sh
export FZF_DEFAULT_OPTS=" \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
