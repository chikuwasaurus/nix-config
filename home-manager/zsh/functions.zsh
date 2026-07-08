# Search with ripgrep, preview matches in fzf, and open selected locations in Helix.
rgh() {
  rg --hidden --glob '!.git' --column --line-number --no-heading --color=always --smart-case "$*" |
    fzf \
      --multi \
      --ansi \
      --delimiter ':' \
      --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
      --preview-window 'right,60%,border-left,+{2}+3/3' |
        awk -F : '{print $1 ":" $2 ":" $3}' |
        xargs -r hx
}

# Search files with fd, preview them in fzf, and open selected files in Helix.
fdh() {
  fd --hidden --exclude .git --follow "$*" |
    fzf \
      --multi \
      --preview '
        if [ -d {} ]; then
          eza --tree --level=2 --color=always {}
        else
          bat --style=numbers --color=always {}
        fi
      ' \
      --preview-window 'right,60%,border-left' |
      xargs -r hx
}
