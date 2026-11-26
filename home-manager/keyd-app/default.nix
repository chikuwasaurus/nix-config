{ lib, ... }:

let
  apps = [
    "firefox"
    "chatgpt"
    "dev-noctalia-*"
    "tabularis"
    "md-obsidian-obsidian"
    "net-ankiweb-anki"
  ];

  movements = {
    b = "left";
    f = "right";
    p = "up";
    n = "down";
    a = "home";
    e = "end";
    u = "pageup";
    d = "pagedown";
    h = "backspace";
    k = "macro(S-end delete)";
  };

  keys = builtins.attrNames movements;

  modifiers = {
    "shift" = "S";
    "alt" = "A";
    "meta" = "M";
    "shift+alt" = "S-A";
    "shift+meta" = "S-M";
    "alt+meta" = "A-M";
    "shift+alt+meta" = "S-A-M";
  };

  # Apply Emacs-style bindings to Control alone.
  movementBindings = map (key: "control.${key} = ${movements.${key}}") keys;

  # Preserve the original modifier combinations.
  modifiedBindings = lib.concatLists (
    lib.mapAttrsToList (
      modifier: prefix: map (key: "control+${modifier}.${key} = C-${prefix}-${key}") keys
    ) modifiers
  );

  # Restore native Control shortcuts via Alt.
  altBindings = map (key: "alt.${key} = C-${key}") keys;

  bindings = movementBindings ++ modifiedBindings ++ altBindings;

  mkSection = app: "[${app}]\n" + lib.concatStringsSep "\n" bindings;

in
{
  xdg.configFile."keyd/app.conf".text = lib.concatStringsSep "\n\n" (map mkSection apps) + "\n";
}
