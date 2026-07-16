# nix-config

Personal macOS configuration managed with
[nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

## Overview

This setup uses:

- **Nix flakes** for reproducible configuration
- **nix-darwin** for macOS system-level configuration
- **home-manager** for user-level dotfiles and programs
- **Homebrew integration** for macOS GUI applications and casks

Supported configurations:

| Configuration            | Platform        | Architecture     |
| ------------------------ | --------------- | ---------------- |
| `Kyoheis-Mac-mini`       | macOS           | `aarch64-darwin` |
| `Kyoheis-MacBook-Air`    | macOS           | `aarch64-darwin` |
| `kyohei@apple-container` | Linux container | `aarch64-linux`  |
| `kyohei@omarchy`         | Omarchy Linux   | `x86_64-linux`   |

## macOS

### Initial Setup

1. Install [Nix](https://nixos.org/download/#nix-install-macos):

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

## Linux (Omarchy)

### Initial Setup

1. Install [Nix](https://nixos.org/download/#nix-install-linux) in multi-user mode:

   ```sh
   curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
   ```

   Load Nix into the current shell:

   ```sh
   source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
   ```

2. Configure the Nix daemon:

   ```sh
   sudo tee -a /etc/nix/nix.conf > /dev/null <<'EOF'
   extra-experimental-features = nix-command flakes
   extra-substituters = https://cache.numtide.com
   extra-trusted-public-keys = niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=
   EOF

   sudo systemctl restart nix-daemon.service
   ```

   The binary cache is also declared in `flake.nix`, but the system-level
   configuration above is required to allow the Nix daemon to trust and use it
   for unprivileged users.

3. Clone this repository:

   ```sh
   git clone https://github.com/chikuwasaurus/nix-config.git ~/Developer/nix-config
   cd ~/Developer/nix-config
   ```

4. Build and apply the Home Manager configuration:

   ```sh
   nix run github:nix-community/home-manager -- switch --flake .#kyohei@omarchy -b backup
   ```

5. Restart your shell or log out and back in

### Daily Usage

- Apply Home Manager changes:

    ```sh
    just omarchy
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
