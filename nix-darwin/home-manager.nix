# The flake-based setup of the Home Manager nix-darwin module.
# https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nix-darwin-module
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."kyohei" = ../home-manager/home.nix;
}
