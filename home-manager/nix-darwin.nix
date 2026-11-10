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
in
{
  home.packages = with pkgs; [
    container
  ];

  xdg.configFile = {
    "container".source = mkLink "container";
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
    "snapzy".source = mkLink "snapzy";
  };
}
