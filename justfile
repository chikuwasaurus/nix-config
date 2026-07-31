# Show available recipes.
default:
    @just --list

# Enter the devshell
dev:
    nix develop

# Run format
fmt:
    nix fmt

# Run checks
check:
    nix flake check -L

# Build and apply NixOS system and Home Manager changes
nixos:
    sudo nixos-rebuild switch --flake .

# Update inputs and apply the NixOS configuration
nixos-update:
    nix flake update
    sudo nixos-rebuild switch --flake .
    flatpak update

# Build and apply macOS system and Home Manager changes
darwin:
    sudo darwin-rebuild switch --flake .

# Update inputs and apply the nix-darwin configuration
darwin-update:
    nix flake update
    sudo darwin-rebuild switch --flake .
    brew upgrade

# Apply Home Manager inside Apple container
container:
    home-manager switch --flake .#kyohei@apple-container -b backup

# Update all flake inputs
update:
    nix flake update

# Update nixpkgs and llm-agents
pkgs:
    nix flake update nixpkgs llm-agents

# Update only llm-agents, then apply changes
ai:
    nix flake update llm-agents
