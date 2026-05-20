{ config, ... }:

let
  nixConfigPath = "${config.home.homeDirectory}/Developer";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/home-manager/${path}";
in
{
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".gitconfig".source = mkLink ./git/.gitconfig;
    ".zprofile".source = mkLink ./zsh/.zprofile;
    ".zshrc".source = mkLink ./zsh/.zshrc;

    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # ~/.config
  xdg.configFile = {
    "ghostty".source = mkLink ./ghostty;
    "nushell".source = mkLink ./nushell;
    "nvim".source = mkLink ./nvim;
    "sheldon".source = mkLink ./sheldon;
    "starship.toml".source = mkLink ./starship/starship.toml;
    "zed".source = mkLink ./zed;
  };
}
