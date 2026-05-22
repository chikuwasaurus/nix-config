{
  self,
  pkgs,
  ...
}:
{
  imports = [
    ./home-manager.nix
    ./homebrew.nix
  ];

  # Allow unfree packages
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  system = {
    stateVersion = 7;

    # Required when changing user settings on your Mac
    primaryUser = "kyohei";

    # The Git revision of the top-level flake from which this configuration was built.
    configurationRevision = self.rev or self.dirtyRev or null;

    defaults = {
      dock = {
        autohide = true; # Automatically hide and show the Dock
        tilesize = 48; # Icon size
        show-recents = false; # Don't show recent applications
        orientation = "right"; # Dock position
        expose-group-apps = true; # Group windows by application
      };

      finder = {
        AppleShowAllExtensions = true; # Show all file extensions
        AppleShowAllFiles = true; # Show hidden files
        ShowPathbar = true; # Show path bar
        ShowStatusBar = true; # Show status bar
        FXPreferredViewStyle = "clmv"; # Column view by default
        NewWindowTarget = "Other"; # Open ~/Downloads by default
        NewWindowTargetPath = "file:///Users/kyohei/Downloads"; # Open ~/Downloads by default
      };

      magicmouse = {
        MouseButtonMode = "TwoButton";
      };

      trackpad = {
        Clicking = true; # Enable tap to click
        TrackpadRightClick = true; # Enable right click (two-finger tap/click)
      };

      screencapture = {
        location = "~/Downloads";
        type = "png";
        target = "clipboard"; # Save screenshot to clipboard
      };

      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 3.0;
      };

      # Global macOS settings
      NSGlobalDomain = {
        # Appearance
        AppleInterfaceStyle = "Dark"; # Dark mode

        # Keyboard
        KeyRepeat = 2; # Fast key repeat (1-2 is very fast)
        InitialKeyRepeat = 15; # Initial key repeat delay
        ApplePressAndHoldEnabled = false; # Repeat keys by holding down
        "com.apple.keyboard.fnState" = true; # Use F1, F2, etc. keys as standard function keys.

        # Trackpad
        "com.apple.trackpad.forceClick" = false;
        "com.apple.trackpad.scaling" = 3.0;

        # Window
        # https://github.com/nikitabobko/AeroSpace#tip-of-the-day
        NSWindowShouldDragOnGesture = true; # Move window by holding anyware

        # Disable auto-correct and substitutions
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };

      CustomUserPreferences = {
        "com.apple.symbolichotkeys" = {
          AppleSymbolicHotKeys = {
            # Spotlight > "Show Spotlight search"
            # Shortcut: Command + Shift + Space
            "64" = {
              enabled = true;
              value = {
                type = "standard";
                parameters = [
                  32 # ASCII: Space
                  49 # macOS key code: Space
                  1179648 # Command (1048576) + Shift (131072) modifier mask
                ];
              };
            };
          };
        };
        "com.apple.inputmethod.Kotoeri" = {
          JIMPrefLiveConversionKey = false; # Disable Live Conversion for the Japanese input method.
          JIMPrefPredictiveCandidateKey = false; # Disable predictive candidates in the Japanese input method's candidate window.
        };
      };

      hitoolbox.AppleFnUsageType = "Start Dictation";
    };

    # Disabled because Karabiner-Elements now owns these key remaps.
    # Avoids conflicting/double remaps for Caps Lock, Control, and Escape.
    #
    # keyboard = {
    #   enableKeyMapping = true;
    #   remapCapsLockToControl = true; # CapsLock -> Control
    #   userKeyMapping = [
    #     # Left Control -> Escape
    #     {
    #       HIDKeyboardModifierMappingSrc = 30064771296; # 0x7000000E0 = Left Control
    #       HIDKeyboardModifierMappingDst = 30064771113; # 0x700000029 = Escape
    #     }
    #   ];
    # };
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    watchIdAuth = true;
  };

  # Define the user's home directory for nix-darwin/home-manager.
  # https://nix-community.github.io/home-manager/index.xhtml#sec-install-nix-darwin-module
  users.users."kyohei" = {
    home = "/Users/kyohei";
  };
}
