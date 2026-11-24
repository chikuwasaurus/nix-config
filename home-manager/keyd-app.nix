{
  lib,
  ...
}:

let
  apps = [
    "firefox*"
    "chatgpt*"
    "dev-noctalia-*"
    "tabularis*"
  ];

  keys = [
    "b"
    "f"
    "p"
    "n"
    "a"
    "e"
    "u"
    "d"
    "h"
    "k"
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

  modifiers = [
    "shift"
    "alt"
    "meta"
    "shift+alt"
    "shift+meta"
    "alt+meta"
    "shift+alt+meta"
  ];

  movementBindings = map (key: "control.${key} = ${movements.${key}}") keys;

  modifiedBindings = lib.concatMap (
    modifier: map (key: "control+${modifier}.${key} = C-M-${key}") keys
  ) modifiers;

  altBindings = map (key: "alt.${key} = C-${key}") keys;

  bindings = movementBindings ++ modifiedBindings ++ altBindings;

  mkSection = app: "[${app}]\n" + lib.concatStringsSep "\n" bindings;

in
{
  xdg.configFile."keyd/app.conf".text = lib.concatStringsSep "\n\n" (map mkSection apps) + "\n";
}
