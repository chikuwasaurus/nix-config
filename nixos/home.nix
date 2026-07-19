{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "kyohei";
  home.homeDirectory = "/home/kyohei";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    gh
    git
    helix

    ghostty
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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
