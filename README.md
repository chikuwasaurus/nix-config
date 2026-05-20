# nix-config

Personal macOS configuration managed with
[nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

## Overview

This setup uses:

- **Nix flakes** for reproducible configuration
- **nix-darwin** for macOS system-level configuration
- **home-manager** for user-level dotfiles and programs
- **Homebrew integration** for macOS GUI applications and casks

## Initial Setup

1. Install [Nix](https://nixos.org/download/):

    ```sh
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
    ```

2. Clone this repository:

    ```sh
    git clone https://github.com/chikuwasaurus/nix-config.git ~/Developer/nix-config
    cd ~/Developer/nix-config
    ```

3. Build and apply the [nix-darwin](https://github.com/nix-darwin/nix-darwin) configuration
(this will also install Homebrew automatically):

    ```sh
    sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .
    ```

4. Reload your shell:

    ```sh
    exec nu
    ```

## Daily Usage

- Build and apply changes:

    ```sh
    sudo darwin-rebuild switch --flake .
    ```

- Update flake inputs (dependencies):

    ```sh
    nix flake update
    sudo darwin-rebuild switch --flake .
    ```

- Update only AI CLI

    ```sh
    nix flake update claude-code codex-cli-nix
    home-manager switch --flake .
    ```
