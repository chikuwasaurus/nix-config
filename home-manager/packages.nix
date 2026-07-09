{ pkgs, ... }:

let
  # Nix-managed wrapper for czg.
  # This avoids global npm/bun installs and pins the czg version used by Bun.
  #
  # Note: Bun still resolves/downloads the package at runtime, so this is not
  # fully Nix-reproducible.
  czg = pkgs.writeShellApplication {
    name = "czg";
    runtimeInputs = [ pkgs.bun ];
    text = ''
      exec ${pkgs.bun}/bin/bunx czg@1.13.1 "$@"
    '';
  };
in
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
    shfmt
    starship
    taplo
    tlrc
    uv
    vscode-json-languageserver
    xh
    yazi
    yq
    zoxide
  ]
  ++ [
    czg
  ]
  ++ (with pkgs.llm-agents; [
    claude-code
    codex
    herdr
    hunk
  ]);
}
