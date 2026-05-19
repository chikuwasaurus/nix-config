{
  nix-homebrew,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    user = "kyohei";
    enableRosetta = false;
    autoMigrate = true;
  };

  homebrew = {
    enable = true;
    user = "kyohei";
    # onActivation.cleanup = "zap";
    # enableZshIntegration = true;

    brews = [
      "mas"
    ];

    casks = [
      "anki"
      "chatgpt"
      "chatgpt-atlas"
      "claude"
      "claude-code"
      "cleanshot"
      "cmux"
      "codex"
      "cursor"
      "figma"
      "ghostty"
      "google-chrome"
      "logi-options+"
      "ogdesign-eagle"
      "orbstack"
      "pixelsnap"
      "proxyman"
      "raycast"
      "slack"
      "tableplus"
      "zed"
    ];

    masApps = {
      "Control Panel for Twitter" = 1668516167;
      "Control Panel for YouTube" = 6478456678;
      "Developer" = 640199958;
      "Dropover" = 1355679052;
      "Eagle for Safari" = 1526651672;
      "Final Cut Pro" = 1631624924;
      "Flow" = 1423210932;
      "Keepa - Price Tracker" = 1533805339;
      "Keynote" = 361285480;
      "Kindle" = 302584613;
      "Logic Pro" = 1615087040;
      "Motion" = 6746637149;
      "Noir" = 1592917505;
      "Numbers" = 361304891;
      "Pages" = 361309726;
      "Photomator" = 1444636541;
      "Pixelmator Pro" = 6746662575;
      "TestFlight" = 899247664;
      "TextSniper" = 1528890965;
      "Wappalyzer - Technology profiler" = 1520333300;
      "Xcode" = 497799835;
    };
  };
}
