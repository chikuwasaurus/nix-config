# ~/.zshenv

if [ -z "$USER" ]; then
  USER="$(id -un 2>/dev/null || echo kyohei)"
  export USER
fi

if [ -z "$LOGNAME" ]; then
  LOGNAME="$USER"
  export LOGNAME
fi

if [ -z "$HOME" ]; then
  HOME="$(awk -F: -v user="$USER" '$1 == user { print $6 }' /etc/passwd)"
  : "${HOME:=/home/$USER}"
  export HOME
fi

if [ -z "$SHELL" ]; then
  SHELL="$(awk -F: -v user="$USER" '$1 == user { print $7 }' /etc/passwd)"
  : "${SHELL:=/bin/zsh}"
  export SHELL
fi
