{
  description = "Nix Configuration";

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
      "https://helix.cachix.org"
      "https://ghostty.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
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
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    helix.url = "github:helix-editor/helix";
    ghostty.url = "github:ghostty-org/ghostty";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      nix-homebrew,
      noctalia-greeter,
      nix-flatpak,
      disko,
      git-hooks,
      ...
    }:
    let
      username = "kyohei";

      mkDarwin =
        hostname:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs username hostname;
          };
          modules = [
            ./nix-darwin/configuration.nix
            nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
            (mkHomeManagerModule ./home-manager/nix-darwin.nix)
          ];
        };

      mkNixOS =
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs username hostname;
          };
          modules = [
            ./nixos/configuration.nix
            nix-flatpak.nixosModules.nix-flatpak
            home-manager.nixosModules.home-manager
            (mkHomeManagerModule ./home-manager/nixos.nix)
            noctalia-greeter.nixosModules.default
            disko.nixosModules.disko
          ];
        };

      mkHomeManagerModule = homeModule: {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username}.imports = [
            ./home-manager/common.nix
            homeModule
          ];
          backupFileExtension = "backup";
          extraSpecialArgs = {
            inherit inputs username;
          };
        };
      };

      mkHome =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
          };
          extraSpecialArgs = {
            inherit inputs username;
          };
          modules = [
            ./home-manager/common.nix
          ];
        };

      inherit (nixpkgs) lib;

      systems = [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems = lib.genAttrs systems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations."nixos" = mkNixOS "nixos";
      darwinConfigurations = {
        "mac-mini" = mkDarwin "mac-mini";
        "macbook-air" = mkDarwin "macbook-air";
      };
      homeConfigurations."${username}@apple-container" = mkHome "aarch64-linux";

      # nix fmt
      formatter = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        pkgs.nixfmt-tree
      );

      # nix flake check
      checks = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          git-hooks = git-hooks.lib.${system}.run {
            src = self;
            hooks = {
              nix-flake-check = {
                enable = true;
                name = "nix flake check";
                entry = toString (
                  pkgs.writeShellScript "nix-flake-check-head" ''
                    set -euo pipefail

                    repo="$(${pkgs.lib.getExe pkgs.git} rev-parse --show-toplevel)"
                    rev="$(${pkgs.lib.getExe pkgs.git} rev-parse HEAD)"

                    # Check the committed HEAD only, excluding staged, unstaged, and untracked changes.
                    exec ${pkgs.lib.getExe pkgs.nix} flake check \
                      "git+file://$repo?rev=$rev"
                  ''
                );
                pass_filenames = false;
                always_run = true;
                stages = [ "pre-push" ];
              };
            };
          };

          statix =
            pkgs.runCommand "statix-check"
              {
                src = self;
                nativeBuildInputs = [
                  pkgs.statix
                ];
              }
              ''
                statix check ${self}
                touch "$out"
              '';

          deadnix =
            pkgs.runCommand "deadnix-check"
              {
                src = self;
                nativeBuildInputs = [
                  pkgs.deadnix
                ];
              }
              ''
                deadnix --fail ${self}
                touch "$out"
              '';
        }
      );

      # nix develop
      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          gitHooks = self.checks.${system}.git-hooks;
        in
        {
          default = pkgs.mkShellNoCC {
            inherit (gitHooks) shellHook;
            buildInputs = gitHooks.enabledPackages;

            packages = with pkgs; [
              nixfmt
              statix
              deadnix
              just
            ];
          };
        }
      );
    };
}
