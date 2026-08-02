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
# 隠しファイルを補完に表示する
setopt GLOB_DOTS

# zsh のビルトインコマンドに対して help コマンドを使えるようにする
unalias run-help 2>/dev/null
autoload -Uz run-help
alias help=run-help

# aliases
alias grep="grep --color=auto"
alias ls="ls --color=auto"
alias l="eza -F auto"
alias la='eza -aF auto'
alias ll='eza -lahHF --git --git-repos-no-status --icons=always --color=always'
alias lt='eza --tree --all --git-ignore --icons=always --color=always'
alias rm="gomi"

# Use macOS's native whatis database for keyword searches.
# Nix's man-db handles GNU/Nix manpages better, but its `man -k` does not
# reliably include macOS system manpages such as zsh.
alias mank="/usr/bin/man -k"

# Show other users' processes
# https://github.com/dalance/procs#permissions-issues
alias procs="sudo procs"

# Use the app-bundled Tailscale CLI on macOS.
if [[ "$OSTYPE" == darwin* ]]; then
  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
fi

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

# direnv
eval "$(direnv hook zsh)"
