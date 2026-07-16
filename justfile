# Build and apply macOS system and Home Manager changes
switch:
    sudo darwin-rebuild switch --flake .

# Update all flake inputs, then apply macOS system and Home Manager changes
update:
    nix flake update
    sudo darwin-rebuild switch --flake .

# Update nixpkgs and llm-agents, then apply changes and upgrade Homebrew packages
packages:
    nix flake update nixpkgs llm-agents
    sudo darwin-rebuild switch --flake .
    brew upgrade -g

# Update only llm-agents, then apply changes
ai:
    nix flake update llm-agents
    sudo darwin-rebuild switch --flake .

# Apply Home Manager on Omarchy
omarchy:
    home-manager switch --flake .#kyohei@omarchy -b backup

# Apply Home Manager inside Apple container
container:
    home-manager switch --flake .#kyohei@apple-container -b backup
