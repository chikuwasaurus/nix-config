{ config, pkgs, ... }:

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

    profiles."8oj7uhz3.default" = {
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userContent = ''
        @-moz-document domain("chatgpt.com") {
          /*
           * Use the Japanese-aware sans-serif fallback instead of Firefox's
           * system-ui fallback on ChatGPT.
           */
          body,
          button,
          input,
          select,
          textarea {
            font-family: sans-serif !important;
          }
        }
      '';
    };
  };
}
