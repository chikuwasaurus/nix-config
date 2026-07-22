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
    extra-substituters = [
      "https://cache.numtide.com"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
     "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
     "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
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
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      llm-agents,
      noctalia,
      noctalia-greeter,
      ...
    }:
    let
      mkHomeManagerModule = homeModule: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users."kyohei".imports = [
            ./home-manager/common.nix
            homeModule
          ];
          backupFileExtension = "backup";
        };
      };

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
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            (mkHomeManagerModule ./home-manager/nix-darwin.nix)
          ];
        };

      mkHome =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              llm-agents.overlays.shared-nixpkgs
            ];
          };
          modules = [
            {
              home.username = "kyohei";
              home.homeDirectory = "/home/kyohei";
            }
            ./home-manager/common.nix
          ];
        };
    in
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        modules = [
          ./nixos/configuration.nix
          {
            nixpkgs.overlays = [
              llm-agents.overlays.shared-nixpkgs
            ];
          }
          home-manager.nixosModules.home-manager
          (mkHomeManagerModule ./home-manager/nixos.nix)
          noctalia.nixosModules.default
          noctalia-greeter.nixosModules.default
        ];
      };
      darwinConfigurations."Kyoheis-Mac-mini" = mkDarwin "Kyoheis-Mac-mini";
      darwinConfigurations."Kyoheis-MacBook-Air" = mkDarwin "Kyoheis-MacBook-Air";
      homeConfigurations."kyohei@apple-container" = mkHome "aarch64-linux";
      homeConfigurations."kyohei@omarchy" = mkHome "x86_64-linux";
    };
}
