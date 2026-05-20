# The flake-based setup of the Home Manager nix-darwin module.
# https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nix-darwin-module
{ inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = {
      inherit inputs;
    };

    users."kyohei" = ../home-manager/home.nix;
  };
}
