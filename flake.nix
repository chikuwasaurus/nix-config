{
  description = "Home Manager configuration of kyohei";

  nixConfig = {
    # Use numtide's binary cache for llm-agents.nix.
    #
    # Keep llm-agents.nix on its own pinned nixpkgs input instead of
    # `inputs.nixpkgs.follows = "nixpkgs"`.
    # This matches the nixpkgs revision used by llm-agents.nix CI and makes
    # pre-built binaries more likely to be fetched instead of rebuilt locally.
    #
    # https://github.com/numtide/llm-agents.nix#binary-cache
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

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
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      llm-agents,
      ...
    }:
    let
      mkDarwin =
        hostname:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit self;
          };
          modules = [
            ./nix-darwin/configuration.nix
            {
              networking.hostName = hostname;
              networking.localHostName = hostname;
              nixpkgs.hostPlatform = "aarch64-darwin";

              nixpkgs.overlays = [
                llm-agents.overlays.shared-nixpkgs
              ];
            }
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
          ];
        };
    in
    {
      darwinConfigurations."Kyoheis-Mac-mini" = mkDarwin "Kyoheis-Mac-mini";
      darwinConfigurations."Kyoheis-MacBook-Air" = mkDarwin "Kyoheis-MacBook-Air";

      homeConfigurations."kyohei@apple-container" =
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-linux";
            overlays = [
              llm-agents.overlays.shared-nixpkgs
            ];
          };
          modules = [
            ./home-manager/home.nix
          ];
        };
    };
}
