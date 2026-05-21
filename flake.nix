{
  description = "Home Manager configuration of kyohei";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    claude-code.url = "github:sadjow/claude-code-nix";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      ...
    }:
    let
      mkDarwin =
        hostname:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit self inputs;
          };
          modules = [
            ./nix-darwin/configuration.nix
            {
              networking.hostName = hostname;
              networking.localHostName = hostname;
              nixpkgs.hostPlatform = "aarch64-darwin";
            }
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
          ];
        };
    in
    {
      darwinConfigurations."Kyoheis-Mac-mini" = mkDarwin "Kyoheis-Mac-mini";
      darwinConfigurations."Kyoheis-MacBook-Air" = mkDarwin "Kyoheis-MacBook-Air";
    };
}
