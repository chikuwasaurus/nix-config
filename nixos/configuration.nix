# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  username,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./disko.nix
    ./flatpak.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Enable the BlueZ Bluetooth stack.
  hardware.bluetooth.enable = true;

  # Enable power profile management.
  services.power-profiles-daemon.enable = true;

  # Expose battery level, charging state, and AC power information.
  services.upower.enable = true;

  zramSwap.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    # Make the Japanese locale available for locale-sensitive applications
    # while keeping English as the system-wide default.
    extraLocales = [
      "ja_JP.UTF-8/UTF-8"
    ];
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  users.groups = {
    # Create a dedicated group for accessing the Apple Studio Display's HID interface.
    "studio-display" = { };
    # Create a group that can access the keyd IPC socket.
    "keyd" = { };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "studio-display" # Allow this user to control the Studio Display without sudo.
      "input" # Allow the user to access devices under /dev/input.
      "keyd" # Allow the application mapper to communicate with keyd.
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  # services.getty.autologinUser = username;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.zsh = {
    enable = true;
    # loginShellInit = ''
    #   if uwsm check may-start; then
    #     exec uwsm start hyprland.desktop
    #   fi
    # '';
  };

  programs.noctalia = {
    enable = true;
    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
    systemd.enable = true;
  };

  programs.noctalia-greeter = {
    enable = true;
    settings = {
      session = {
        default = "Hyprland (uwsm-managed)";
      };
      idle = {
        timeout = 300;
      };
      keyboard = {
        layout = "us";
      };
    };
  };

  # Sync Noctalia Shell theme with Nocalia Greeter
  security.polkit.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    asdbctl
    evtest # Identify and read keyboard input devices.
    gpu-screen-recorder
    config.services.keyd.package # Make the keyd CLI tools available system-wide.
    kitty
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wl-clipboard
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable keyring.
  services.gnome.gnome-keyring.enable = true;
  # security.pam.services.login.enableGnomeKeyring = true;

  services.udev.extraRules = ''
    # Grant read/write access to the Studio Display HID interface for
    # members of the "studio-display" group.
    #
    # 05ac: Apple USB vendor ID
    # 1114: Apple Studio Display product ID
    SUBSYSTEM=="hidraw", KERNEL=="hidraw*", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="1114", GROUP:="studio-display", MODE:="0660"

    # Create a stable device path for keyd's virtual keyboard.
    SUBSYSTEM=="input", KERNEL=="event*", ATTRS{name}=="keyd virtual keyboard", GROUP="input", MODE="0660", SYMLINK+="input/by-id/keyd-virtual-keyboard"
  '';

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable tailscale client daemon.
  services.tailscale.enable = true;

  # Enable a key remapping daemon.
  services.keyd = {
    enable = true;

    keyboards = {
      default = {
        ids = [ "*" ];

        settings = {
          main = {
            # Use Caps Lock as Control while held.
            capslock = "layer(control)";
            # capslock = "overload(control, esc)";

            # Use the Control keys as Escape.
            leftcontrol = "esc";
            rightcontrol = "esc";

            # Preserve Right Super as Right Super
            rightmeta = "rightmeta";
          };

          control = {
            h = "backspace";
            # Send Escape when Ctrl+semicolon is pressed.
            semicolon = "esc";
          };
        };


        extraConfig = ''
          # Define the composite layer so app.conf can modify it.
          [control+shift]
        '';
      };
    };
  };

  # Allow keyd to switch its effective group to the keyd group.
  # see: https://github.com/NixOS/nixpkgs/issues/290161
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet =
    lib.mkAfter [
      "CAP_SETGID"
    ];

  # IME
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      # Hyprland
      waylandFrontend = true;

      addons = with pkgs; [
        fcitx5-mozc-ut
        fcitx5-gtk

        # Install Catppuccin themes with rounded corners
        (catppuccin-fcitx5.override {
          withRoundedCorners = true;
        })
      ];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
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
    trusted-users = [
      "root"
      username
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      udev-gothic-nf
    ];

    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif"
          "Noto Serif CJK JP"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK JP"
        ];
        monospace = [
          "UDEV Gothic 35NF"
          "Noto Sans Mono CJK JP"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };

      # CSS UI generic families are not always resolved through sans-serif.
      aliases = {
        "ui-sans-serif" = {
          binding = "same";
          prefer = [
            "Noto Sans"
            "Noto Sans CJK JP"
          ];
        };

        "system-ui" = {
          binding = "same";
          prefer = [
            "Noto Sans"
            "Noto Sans CJK JP"
          ];
        };
      };
    };
  };

  # Allow unfree packages
  nixpkgs = {
    config.allowUnfree = true;
  };
}
