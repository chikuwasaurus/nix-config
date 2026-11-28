{
  lib,
  buildNpmPackage,
  nodejs_24,
  makeWrapper,
}:

buildNpmPackage {
  pname = "yanki";

  version = (builtins.fromJSON (builtins.readFile ./package.json)).dependencies.yanki;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./package.json
      ./package-lock.json
    ];
  };

  nodejs = nodejs_24;

  npmDepsHash = "sha256-bHgY14oBVBgNiMi142C9n67+uQ0v2zOxMtua04IAtiw=";

  nativeBuildInputs = [ makeWrapper ];

  # Use the prebuilt package from npm.
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/yanki $out/bin
    cp -r node_modules $out/lib/yanki/

    makeWrapper ${nodejs_24}/bin/node $out/bin/yanki \
      --add-flags "$out/lib/yanki/node_modules/yanki/dist/bin/cli.js"

    runHook postInstall
  '';

  meta = {
    description = "Turn Markdown into Anki flashcards";
    homepage = "https://github.com/kitschpatrol/yanki";
    license = lib.licenses.mit;
    mainProgram = "yanki";
    platforms = lib.platforms.unix;
  };
}
