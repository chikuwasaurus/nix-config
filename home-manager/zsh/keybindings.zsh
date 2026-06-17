function select_dev_project() {
  fd . "$HOME/Developer" -d 1 -t d \
    | sed "s|^$HOME/Developer/||" \
    | fzf --preview 'bat --color=always --line-range :80 "$HOME/Developer"/{}/README.* 2>/dev/null'
}

function hx_dev_project() {
  local dir
  dir="$(select_dev_project)"
  [[ -z "$dir" ]] && return

  BUFFER="hx \"$HOME/Developer/$dir\""
  zle accept-line
}

function zed_dev_project() {
  local dir
  dir="$(select_dev_project)"
  [[ -z "$dir" ]] && return

  BUFFER="zed \"$HOME/Developer/$dir\""
  zle accept-line
}

zle -N hx_dev_project
zle -N zed_dev_project

bindkey '^G' hx_dev_project
bindkey '^Z' zed_dev_project
