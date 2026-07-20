{ config, pkgs, ... }:

{
  # Use a dark theme for GTK applications.
  gtk = {
    enable = true;
    colorScheme = "dark";
  };

  # Use a dark theme for Qt applications.
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    brave
    ghostty
  ];

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "hx";
    };
    shellAliases = {
      btw = "echo 'i use hyprland btw'";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] \
         && [ "$XDG_VTNR" = "1" ] \
         && [ -z "$SSH_CONNECTION" ]; then
         exec start-hyprland
      fi
    '';
  };
}
