# zsh の設定ファイルのディレクトリを指定する
# ZDOTDIR を指定しない場合は、代わりに HOME が使われる
export ZDOTDIR=$HOME/.config/zsh

# editor を helix に設定
export EDITOR=hx

# zsh でターミナルの出力が改行されずに最後の行に到達したとき、末尾に記号(%や#)が表示されないようにする
# export PROMPT_EOL_MARK=''

# Treat Nerd Font Private Use Area glyphs as printable in less.
# Without this, icons from tools like eza may disappear or break when viewed
# through less or pagers that use less, such as bat.
#
# Ranges:
#   E000-F8FF       BMP Private Use Area
#   F0000-FFFFD     Supplementary Private Use Area-A
#   100000-10FFFD   Supplementary Private Use Area-B
export LESSUTFCHARDEF='E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p'

# fzf を Catppuccin Mocha theme にする
# https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-mocha.sh
export FZF_DEFAULT_OPTS=" \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

# eza
export EZA_CONFIG_DIR="$HOME/.config/eza"

# macOS Terminal.app に ~/.zsh_sessions を作成させない
export SHELL_SESSIONS_DISABLE=1

# Colorize man pages.
export MANROFFOPT='-c'
export MANPAGER="sh -c 'col -bx | bat --style=plain --language=man'"

# zk
export ZK_NOTEBOOK_DIR="$HOME/Developer/notes"
