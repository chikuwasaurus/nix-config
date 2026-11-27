{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  nixConfigPath = "${config.home.homeDirectory}/Developer/nix-config";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${nixConfigPath}/home-manager/${path}";
  brewPrefix = osConfig.homebrew.prefix;
in
{
  home = {
    packages = with pkgs; [
      emacs
    ];

    sessionVariables = {
      DOCKER_HOST = "unix://${brewPrefix}/var/run/socktainer/.socktainer/container.sock";
    };
  };

  xdg.configFile = {
    "container".source = mkLink "container";
    # Symlink the entire plugin directory to automatically discover Homebrew-installed
    # Docker CLI plugins while keeping config.json writable by Docker.
    "docker/cli-plugins".source =
      config.lib.file.mkOutOfStoreSymlink "${brewPrefix}/lib/docker/cli-plugins";
    "flashspace".source = mkLink "flashspace";
    "ghostty/platform.ghostty" = lib.mkIf (osConfig.networking.hostName == "mac-mini") {
      text = ''
        font-size = 16
      '';
    };
    "git/config.platform".text = ''
      [credential]
          helper =
          helper = osxkeychain
    '';
    "karabiner".source = mkLink "karabiner";
    "omniwm".source = mkLink "omniwm";
    "snapzy".source = mkLink "snapzy";
  };
}
