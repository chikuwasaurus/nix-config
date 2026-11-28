# Yanki

## Updating

1. Update the npm dependency and lockfile.

   ```sh
   cd pkgs/yanki

   nix shell nixpkgs#nodejs_24 -c \
     npm install --package-lock-only --ignore-scripts \
     --save-exact yanki@latest
   ```

2. Set `npmDepsHash` to `lib.fakeHash` in `default.nix`.

3. Rebuild the Nix configuration.

4. Replace `lib.fakeHash` with the actual hash reported
   in the build error.

5. Rebuild and verify the installed version.

   ```sh
   yanki --version
   ```
