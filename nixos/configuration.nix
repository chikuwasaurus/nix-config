# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
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

  # Create a dedicated group for accessing the Apple Studio Display's HID interface.
  users.groups."studio-display" = { };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kyohei = {
    isNormalUser = true;
    home = "/home/kyohei";
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "studio-display" # Allow this user to control the Studio Display without sudo.
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  # services.getty.autologinUser = "kyohei";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.firefox.enable = true;

  programs.zsh = {
    enable = true;
    loginShellInit = ''
      if uwsm check may-start; then
        exec uwsm start hyprland.desktop
      fi
    '';
  };

  programs.noctalia = {
    enable = true;
    # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
    recommendedServices.enable = true;
    systemd.enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    asdbctl
    kitty
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
  security.pam.services.login.enableGnomeKeyring = true;

  # Grant read/write access to the Studio Display HID interface for
  # members of the "studio-display" group.
  #
  # 05ac: Apple USB vendor ID
  # 1114: Apple Studio Display product ID
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", KERNEL=="hidraw*", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="1114", GROUP:="studio-display", MODE:="0660"
  '';

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      udev-gothic-nf
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif CJK JP" ];
      sansSerif = [ "Noto Sans CJK JP" ];
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "UDEV Gothic 35NF" ];
    };
  };
}
