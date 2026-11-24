{
  config,
  username,
  ...
}:

let
  fromRemote =
    origin: appIds:
    map (appId: {
      inherit appId origin;
    }) appIds;
  homeDir = config.users.users.${username}.home;
in
{
  services.flatpak = {
    enable = true;

    uninstallUnmanaged = true;
    uninstallUnused = true;

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
      {
        name = "flatpark";
        location = "https://dl.flatpark.org/flatpark.flatpakrepo";
      }
    ];

    packages =
      fromRemote "flathub" [
        "com.github.tchx84.Flatseal"
        "io.github.flattool.Warehouse"
        "com.obsproject.Studio"
        "net.ankiweb.Anki"
        "md.obsidian.Obsidian"
      ]
      ++ fromRemote "flatpark" [
        "dev.tabularis.Tabularis"
        "ai.storyteller.pdfcraft"
      ];

    overrides = {
      settings = {
        "dev.tabularis.Tabularis" = {
          Context.filesystems = [
            "xdg-config/tabularis:create"
          ];
          Environment.TABULARIS_DATA_DIR = "${homeDir}/.config/tabularis";
        };
      };
    };
  };
}
