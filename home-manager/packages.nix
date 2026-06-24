{ pkgs, ... }:

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
    bottom
    btop
    bun
    codebook
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
    fzf
    gh
    ghq
    git
    git-wt
    go
    gomi
    gping
    helix
    hyperfine
    jq
    just
    just-lsp
    lazydocker
    lazygit
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
    starship
    taplo
    tlrc
    uv
    vscode-json-languageserver
    xh
    yazi
    yq
    zoxide

    llm-agents.claude-code
    llm-agents.codex
    llm-agents.herdr
  ];
}
