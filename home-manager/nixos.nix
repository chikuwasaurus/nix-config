{ config, pkgs, ... }:

let
  nixConfigPath = "${config.home.homeDirectory}/Developer/nix-config";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/home-manager/${path}";
in
{
  # # Use a dark theme for GTK applications.
  # gtk = {
  #   enable = true;
  #   colorScheme = "dark";
  # };

  # # Use a dark theme for Qt applications.
  # qt = {
  #   enable = true;
  #   platformTheme.name = "adwaita";
  #   style.name = "adwaita-dark";
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    ghostty
  ];

  xdg.configFile = {
    "hypr".source = mkLink "hypr";
    "noctalia".source = mkLink "noctalia";
    # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#nixos-uwsm
    "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };
}
