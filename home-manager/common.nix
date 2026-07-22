{
  config,
  pkgs,
  ...
}:

let
  # username = "kyohei";
  nixConfigPath = "${config.home.homeDirectory}/Developer/nix-config";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/home-manager/${path}";
in
{
  imports = [ ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # home.username = username;
  # home.homeDirectory =
  #   if pkgs.stdenv.isDarwin then
  #     "/Users/${username}"
  #   else
  #     "/home/${username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/kyohei/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  home.sessionPath = [
    # "$HOME/.local/bin"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Whether to enable management of XDG base directories.
  # https://nix-community.github.io/home-manager/options.xhtml#opt-xdg.enable
  xdg.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    atuin
    bash-language-server
    bat
    bottom
    btop
    bun
    carapace
    codebook
    coreutils
    curl
    delta
    deno
    difftastic
    direnv
    doggo
    duf
    dust
    eza
    fastfetch
    fd
    findutils
    fish
    fzf
    gawk
    gh
    ghq
    git
    git-wt
    gnugrep
    gnused
    gnutar
    go
    gomi
    gping
    helix
    hyperfine
    jq
    jujutsu
    jjui
    just
    just-lsp
    lazydocker
    lazygit
    less
    mise
    nixd # Nix LSP
    nixfmt # Nix formatter
    nodejs_24
    nushell
    oha
    pnpm
    procs
    qpdf
    ripgrep
    scooter
    sd
    sheldon
    shellcheck
    shfmt
    starship
    tlrc
    tombi
    tree
    uv
    vscode-json-languageserver
    xh
    yazi
    yq
    zoxide
    zsh
    zstd
  ]
  ++ (with pkgs.llm-agents; [
    claude-code
    codex
    herdr
    hunk
  ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
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
    "gh".source = mkLink "gh";
    "ghostty".source = mkLink "ghostty";
    "git".source = mkLink "git";
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
  };
}
