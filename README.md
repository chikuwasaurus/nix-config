# nix-config

Personal macOS configuration managed with
[nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

## Overview

This setup uses:

- **Nix flakes** for reproducible configuration
- **nix-darwin** for macOS system-level configuration
- **home-manager** for user-level dotfiles and programs
- **Homebrew integration** for macOS GUI applications and casks

## macOS

### Initial Setup

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
    sudo nix run \
        --extra-experimental-features "nix-command flakes" \
        nix-darwin/master#darwin-rebuild -- switch --flake .
    ```

4. Restart your machine

### Daily Usage

- Build and apply macOS system and Home Manager changes:

    ```sh
    just switch
    ```

- Update flake inputs (dependencies):

    ```sh
    just update
    ```

- Update packages and Homebrew only:

    ```sh
    just packages
    ```

- Update only AI CLI:

    ```sh
    just ai
    ```

## Linux (Apple container machine)

### Initial Setup

1. Create and Run machine:

    see: [nix-alpine](./containers/nix-alpine/README.md)

2. Apply dotfiles inside the container:

    ```sh
    nix run github:nix-community/home-manager -- switch --flake .#kyohei@apple-container
    ```

3. Restart your container machine

### Daily Usage

- Apply Home Manager changes inside Apple container:

    ```sh
    just container
    ```

### Note

Running Home Manager inside the container updates files under the mounted host home directory.
