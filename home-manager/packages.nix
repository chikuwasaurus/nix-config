{ pkgs, inputs, ... }:

{
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
    bat
    btop
    bun
    curl
    delta
    deno
    difftastic
    dust
    eza
    fastfetch
    fd
    fzf
    gh
    ghq
    git
    git-wt
    go
    helix
    jankyborders
    jq
    lazydocker
    lazygit
    nixd # Nix LSP
    nixfmt # Nix formatter
    nodejs_24
    nushell
    pnpm
    qpdf
    ripgrep
    sd
    sheldon
    starship
    taplo
    tlrc
    tree
    uv
    yazi
    yq
    zoxide

    inputs.claude-code.packages.${pkgs.system}.default # Use latest claude code
    inputs.codex-cli-nix.packages.${pkgs.system}.default # Use latest codex
  ];
}
