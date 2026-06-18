{ config, ... }:

let
  nixConfigPath = "${config.home.homeDirectory}/Developer/nix-config";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/home-manager/${path}";
in
{
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".gitconfig".source = mkLink "git/.gitconfig";
    ".zprofile".source = mkLink "zsh/.zprofile";
    ".zshrc".source = mkLink "zsh/.zshrc";

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
    "aerospace".source = mkLink "aerospace";
    "bat".source = mkLink "bat";
    "flashspace".source = mkLink "flashspace";
    "ghostty".source = mkLink "ghostty";
    "helix".source = mkLink "helix";
    "karabiner".source = mkLink "karabiner";
    "nushell".source = mkLink "nushell";
    "sheldon".source = mkLink "sheldon";
    "starship.toml".source = mkLink "starship/starship.toml";
    "wezterm".source = mkLink "wezterm";
    "yazi".source = mkLink "yazi";
    "zed".source = mkLink "zed";
    "zsh".source = mkLink "zsh";
  };
}
