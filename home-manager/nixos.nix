{
  inputs,
  config,
  pkgs,
  ... }:

let
  nixConfigPath = "${config.home.homeDirectory}/Developer/nix-config";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/home-manager/${path}";
in
{
  # Use a dark theme for GTK applications.
  gtk = {
    enable = true;
    colorScheme = "dark";
  };

  # Use a dark theme for Qt applications.
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [ ];

  xdg.configFile = {
    "fcitx5".source = mkLink "fcitx5";
    "hypr".source = mkLink "hypr";
    "keyd".source = mkLink "keyd";
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

  programs.firefox = {
    enable = true;
    package = null;

    profiles."8oj7uhz3.default" = { };
  };

  programs.ghostty = {
    enable = true;
    package =
      inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  # Run the application mapper as a systemd user service.
  systemd.user.services.keyd-application-mapper = {
    Unit = {
      Description = "Application-specific keyd mapper";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      # Keep the process in the foreground so systemd can supervise it.
      ExecStart = "${pkgs.keyd}/bin/keyd-application-mapper";

      # Restart the mapper if it exits unexpectedly.
      Restart = "on-failure";
      RestartSec = 1;
    };

    Install.WantedBy = [
      "graphical-session.target"
    ];
  };
}
