# nix-alpine

Alpine Linux based image for running Nix inside Apple Container machines.

This image is a small bootstrap environment for using this `nix-config` repository from inside a container machine.

## Build

From the repository root:

```sh
container build --tag nix-alpine-machine ./containers/nix-alpine
```

## Create and start machine

```sh
container machine create --name nix-alpine nix-alpine-machine
container machine run --name nix-alpine --env USER=$USER -it -- zsh -l
```

## Use nix-config

see: [README.md](../../README.md)

## Notes

This image intentionally does not clone or apply this repository during build.

Dotfiles and Home Manager configuration are managed by this repository and used from the shared macOS filesystem.

Alpine with OpenRC is used because it works well as an Apple Container machine image.

The official `nixos/nix` image may not work reliably in that role.
