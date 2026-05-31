# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# nix
. "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
