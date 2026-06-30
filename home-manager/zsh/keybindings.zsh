select_dev_project() {
  fd . "$HOME/Developer" -d 1 -t d \
    | sed "s|^$HOME/Developer/||" \
    | fzf --preview 'bat --color=always --line-range :80 "$HOME/Developer"/{}/README.* 2>/dev/null'
}

cd_dev_project() {
  local dir
  dir="$(select_dev_project)"
  [[ -z "$dir" ]] && return

  BUFFER="cd \"$HOME/Developer/$dir\""
  zle accept-line
}

hx_dev_project() {
  local dir
  dir="$(select_dev_project)"
  [[ -z "$dir" ]] && return

  BUFFER="cd \"$HOME/Developer/$dir\" && hx ."
  zle accept-line
}

zed_dev_project() {
  local dir
  dir="$(select_dev_project)"
  [[ -z "$dir" ]] && return

  BUFFER="cd \"$HOME/Developer/$dir\" && zed ."
  zle accept-line
}

zle -N cd_dev_project
zle -N hx_dev_project
zle -N zed_dev_project

bindkey '^Z' cd_dev_project
bindkey '^O^H' hx_dev_project
bindkey '^O^Z' zed_dev_project


open_lazygit() {
  BUFFER="lazygit"
  zle accept-line
}

open_yazi() {
  BUFFER="yazi"
  zle accept-line
}

zle -N open_lazygit
zle -N open_yazi

bindkey '^O^G' open_lazygit
bindkey '^O^Y' open_yazi


# Start selecting a region in the current ZLE buffer.
# Move the cursor after this, then copy the selected region with Ctrl-x Ctrl-y.
bindkey '^X ' set-mark-command

# Deactivate the selected ZLE region.
bindkey '^X^G' deactivate-region

# Copy the selected ZLE region to the macOS clipboard.
# If no region is active, copy the whole current command line instead.
copy-region-or-buffer-to-clipboard() {
  emulate -L zsh

  local text start end

  if (( REGION_ACTIVE )); then
    if (( MARK < CURSOR )); then
      start=$(( MARK + 1 ))
      end=$CURSOR
    else
      start=$(( CURSOR + 1 ))
      end=$MARK
    fi

    text=${BUFFER[$start,$end]}
  else
    text=$BUFFER
  fi

  print -rn -- "$text" | pbcopy
}

zle -N copy-region-or-buffer-to-clipboard

# Keep Ctrl-y as ZLE's default yank/paste.
# Use Ctrl-x Ctrl-y to copy the selected region or whole buffer to macOS clipboard.
bindkey '^X^Y' copy-region-or-buffer-to-clipboard


# zsh-autosuggestions hooks into named ZLE widgets.
# Since Ctrl-e is bound to our wrapper instead of the built-in `end-of-line`,
# register the wrapper as a whole-suggestion accept widget before loading
# zsh-autosuggestions.
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(move-end-of-line)
# Ctrl-f should still partially accept suggestions one character at a time.
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(move-forward-char)


# Move without selecting.
# These clear the active ZLE region, matching macOS text-field behavior:
# normal movement cancels selection, Shift+movement extends it.

move-backward-char() {
  zle deactivate-region
  zle backward-char
}

move-forward-char() {
  zle deactivate-region
  zle forward-char
}

move-beginning-of-line() {
  zle deactivate-region
  zle beginning-of-line
}

move-end-of-line() {
  zle deactivate-region
  zle end-of-line
}

zle -N move-backward-char
zle -N move-forward-char
zle -N move-beginning-of-line
zle -N move-end-of-line

bindkey '^B' move-backward-char
bindkey '^F' move-forward-char
bindkey '^A' move-beginning-of-line
bindkey '^E' move-end-of-line


# Move while selecting the current ZLE buffer region.
# These widgets make ZLE behave more like macOS text fields:
# Shift + movement starts or extends a selection.
#
# see: ~/.config/ghostty/config.ghostty

select-backward-char() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle backward-char
}

select-forward-char() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle forward-char
}

select-beginning-of-line() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle beginning-of-line
}

select-end-of-line() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle end-of-line
}

select-backward-word() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle backward-word
}

select-forward-word() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle forward-word
}

zle -N select-backward-char
zle -N select-forward-char
zle -N select-beginning-of-line
zle -N select-end-of-line

# Private escape sequences sent by the terminal.
bindkey '\e[1;S-a' select-beginning-of-line
bindkey '\e[1;S-e' select-end-of-line
bindkey '\e[1;S-b' select-backward-char
bindkey '\e[1;S-f' select-forward-char


# Use ^G only as the fzf-git.sh prefix.
# see: ~/.config/sheldon/plugins.toml
bindkey -r '^G'

# Move abort/break to ^G^G.
bindkey '^G^G' send-break
