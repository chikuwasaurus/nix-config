{ pkgs, ... }:

let
  fromRemote =
    origin: appIds:
    map (appId: {
      inherit appId origin;
    }) appIds;
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
      ]
      ++ fromRemote "flatpark" [
        "dev.tabularis.Tabularis"
      ];
  };
}
