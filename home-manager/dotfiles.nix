{
  config,
  lib,
  pkgs,
  ...
}:

let
  nixConfigPath = "${config.home.homeDirectory}/Developer/nix-config";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/home-manager/${path}";
in
{
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".gitconfig".source = mkLink "git/.gitconfig";
    ".ssh".source = mkLink "ssh";
    ".zshenv".source = mkLink "zsh/.zshenv";

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
    "atuin".source = mkLink "atuin";
    "bat".source = mkLink "bat";
    "bottom".source = mkLink "bottom";
    "btop".source = mkLink "btop";
    "delta".source = mkLink "delta";
    "eza".source = mkLink "eza";
    "ghostty".source = mkLink "ghostty";
    "helix".source = mkLink "helix";
    "herdr".source = mkLink "herdr";
    "hunk".source = mkLink "hunk";
    "lazygit".source = mkLink "lazygit";
    "nushell".source = mkLink "nushell";
    "scooter".source = mkLink "scooter";
    "sheldon".source = mkLink "sheldon";
    "starship.toml".source = mkLink "starship/starship.toml";
    "yazi".source = mkLink "yazi";
    "zed".source = mkLink "zed";
    "zsh".source = mkLink "zsh";
    "zsh-abbr".source = mkLink "zsh-abbr";
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    "container".source = mkLink "container";
    "flashspace".source = mkLink "flashspace";
    "karabiner".source = mkLink "karabiner";
  };
}
