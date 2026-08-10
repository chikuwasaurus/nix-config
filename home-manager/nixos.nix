{
  inputs,
  config,
  pkgs,
  ...
}:

let
  nixConfigPath = "${config.home.homeDirectory}/Developer/nix-config";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/home-manager/${path}";
in
{
  xdg.configFile = {
    "fcitx5".source = mkLink "fcitx5";
    "hypr".source = mkLink "hypr";
    "keyd".source = mkLink "keyd";
    "noctalia".source = mkLink "noctalia";
    "nwg-look".source = mkLink "nwg-look";
    "qt6ct".source = mkLink "qt6ct";
    # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#nixos-uwsm
    "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  };

  home = {
    pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    # Packages that should be installed to the user profile.
    packages = with pkgs; [
      brave-origin

      # GTK 3/4 Applications theme
      # See: https://docs.noctalia.dev/noctalia/templates/official/gtk-qt/?section=gtk-34-applications#gtk-34-applications
      adw-gtk3
      nwg-look
      # Qt Applications theme
      # See: https://docs.noctalia.dev/noctalia/templates/official/gtk-qt/?section=qt-applications#qt-applications
      qt6Packages.qt6ct
    ];
  };

  programs = {
    firefox = {
      enable = true;

      profiles.default = {
        id = 0;
        isDefault = true;
        settings = {
          # Enable experimental PWA-style taskbar tabs.
          "browser.taskbarTabs.enabled" = true;
        };
      };
    };
    ghostty = {
      enable = true;
      package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    obsidian = {
      enable = true;
    };
  };

  systemd.user = {
    # Run the application mapper as a systemd user service.
    services.keyd-application-mapper = {
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

    sessionVariables = {
      # Set the Qt platform theme for systemd user services such as XDG portals.
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };
  };
}
