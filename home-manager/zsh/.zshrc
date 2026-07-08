# editor を helix に設定
export EDITOR=hx
# zsh でターミナルの出力が改行されずに最後の行に到達したとき、末尾に記号(%や#)が表示されないようにする
# export PROMPT_EOL_MARK=''

# Disable Ctrl-S / Ctrl-Q terminal flow control to use ctrl-s for forward search
stty -ixon

# 履歴ファイルの保存先
mkdir -p "$HOME/.local/state/zsh"
HISTFILE="$HOME/.local/state/zsh/history"
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
# Prevent accidental Ctrl-D (EOF: End Of File) from exiting the shell.
setopt IGNORE_EOF

# zsh のビルトインコマンドに対して help コマンドを使えるようにする
unalias run-help 2>/dev/null
autoload -Uz run-help
alias help=run-help

# aliases
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias l="eza -F"
alias la='eza -aF'
alias ll='eza -lahHF --git --git-repos-no-status --icons=always --color=always'
alias lt='eza --tree --all --git-ignore --icons=always --color=always'
alias rm="gomi"

# Show other users' processes
# https://github.com/dalance/procs#permissions-issues
alias procs="sudo procs"

# Treat Nerd Font Private Use Area glyphs as printable in less.
# Without this, icons from tools like eza may disappear or break when viewed
# through less or pagers that use less, such as bat.
#
# Ranges:
#   E000-F8FF       BMP Private Use Area
#   F0000-FFFFD     Supplementary Private Use Area-A
#   100000-10FFFD   Supplementary Private Use Area-B
export LESSUTFCHARDEF='E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p'

# keybindings
source "$HOME/.config/zsh/keybindings.zsh"
# functions
source "$HOME/.config/zsh/functions.zsh"

eval "$(starship init zsh)"
# eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(atuin init zsh)"
# sheldon: zsh のプラグインマネージャ
# shell のプラグイン周りは sheldon で管理している(~/.config/sheldon/plugins.toml)。
eval "$(sheldon source)"

# fzf を Catppuccin Mocha theme にする
# https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-mocha.sh
export FZF_DEFAULT_OPTS=" \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
# https://github.com/aloxaf/fzf-tab#configure
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# zsh-abbr: Cursor placement
# https://zsh-abbr.olets.dev/cursor-placement.html#cursor-placement
ABBR_SET_EXPANSION_CURSOR=1

# zsh-abbr: Reminders
# https://zsh-abbr.olets.dev/reminders.html
ABBR_GET_AVAILABLE_ABBREVIATION=1
ABBR_LOG_AVAILABLE_ABBREVIATION=1

# zsh-abbr: Suggestions
# https://zsh-abbr.olets.dev/integrations.html#suggestions
# ZSH_AUTOSUGGEST_STRATEGY=( abbreviations $ZSH_AUTOSUGGEST_STRATEGY )

# eza
export EZA_CONFIG_DIR="$HOME/.config/eza"

# macOS Terminal.app に ~/.zsh_sessions を作成させない
export SHELL_SESSIONS_DISABLE=1
