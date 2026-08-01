# nix-config

Personal system and user configuration managed with Nix.

## Overview

This setup uses:

- **Nix Flakes** for reproducible configuration
- **NixOS** for NixOS system-level configuration
- **nix-darwin** for macOS system-level configuration
- **Home Manager** for user-level dotfiles and programs

Supported configurations:

| Configuration            | Platform        | Architecture     |
| ------------------------ | --------------- | ---------------- |
| `nixos`                  | NixOS           | `x86_64-linux`   |
| `mac-mini`               | macOS           | `aarch64-darwin` |
| `macbook-air`            | macOS           | `aarch64-darwin` |
| `kyohei@apple-container` | Linux container | `aarch64-linux`  |

## Development

Enter the dev shell:

```sh
just dev
```

Run format:

```sh
just fmt
```

Run checks:

```sh
just check
```

## NixOS

### Initial Setup

1. [Download Minimal ISO image](https://nixos.org/download/#nixos-iso)

2. [Create bootable USB flash drive from a Terminal on macOS](https://nixos.org/manual/nixos/stable/#sec-booting-from-usb-macos)
(or [Linux](https://nixos.org/manual/nixos/stable/#sec-booting-from-usb-linux))

   1. Plug in the USB flash drive.

   2. Find the corresponding device with diskutil list.
   You can distinguish them by their size.

       ```sh
       diskutil list

       ...
       /dev/disk4 (external, physical):
          #:                       TYPE NAME                    SIZE       IDENTIFIER
          0:     FDisk_partition_scheme                        *62.5 GB    disk4
          1:                       0xEF                         3.1 MB     disk4s2
                           (free space)                         62.5 GB    -c
       ...
       ```

   3. Make sure all partitions on the device are properly unmounted.
   Replace diskX with your device (e.g. disk1).

      ```sh
      diskutil unmountDisk /dev/disk4
      ```

   4. Then use the dd utility to write the image to the USB flash drive.

      ```sh
      sudo dd if=~/Downloads/nixos-minimal-26.05.4937.\
      8eeec934ae0d-x86_64-linux.iso of=/dev/rdisk4 bs=4m
      ```

      After dd completes, a GUI dialog “The disk you inserted was not readable
      by this computer” will pop up, which can be ignored.

   5. Eject the disk when it is finished.

      ```sh
      diskutil eject /dev/disk4
      ```

3. [Booting from the install medium](https://nixos.org/manual/nixos/stable/#sec-installation-booting)

   1. Plug in the install drive. Then turn on or restart your computer.

   2. Open the boot menu by pressing the appropriate key (e.g. F7),
   which is usually shown on the display on early boot.
   Select the USB flash drive (the option usually contains the word “USB”).

   3. Shortly after selecting the appropriate boot drive,
   you should be presented with a menu with different installer options.
   Leave the default and wait (or press Enter to speed up).

4. [Install NixOS](https://nixos.org/manual/nixos/stable/#sec-installation-manual)

   1. Log in as `root`.

      The installer automatically logs in as the `nixos` user.
      Its password is empty, so `sudo` does not require a password.

      ```sh
      sudo -i
      ```

   2. [Connect to the network.](https://nixos.org/manual/nixos/stable/#sec-installation-manual-networking)

      ```sh
      nmtui
      ```

   3. Clone this repository.

      ```sh
      git clone https://github.com/chikuwasaurus/nix-config.git
      cd nix-config
      ```

   4. [Identify the target disk.](https://github.com/nix-community/disko/blob/master/docs/quickstart.md#step-3-retrieve-the-disk-name)

      List the available block devices:

      ```sh
      lsblk -o NAME,SIZE,MODEL,SERIAL,TYPE

      NAME          SIZE MODEL           SERIAL       TYPE
      zram0        13.6G                              disk
      nvme0n1     931.5G CT1000P3PSSD8   25144F77626C disk
      ├─nvme0n1p1     1G                              part
      └─nvme0n1p2 930.5G                              part
      sda          29.3G USB Flash Drive 1234567890   disk
      └─sda1       29.3G                              part
      ```

      Make sure that the target is the internal SSD rather than
      the installation USB drive.
      The target disk may look like this:

      `/dev/nvme0n1`

      To find its persistent device path, run:

      ```sh
      ls -l /dev/disk/by-id/ | grep nvme
      ```

      The persistent path may look like this:

      `/dev/disk/by-id/nvme-CT1000P3PSSD8_25144F77626C`

   5. Check `nix-config/nixos/disko.nix`.

      Before running disko, verify that the `device` value in disko.nix
      points to the correct disk:

      `disko.devices.disk.main.device = "/dev/disk/by-id/nvme-CT1000P3PSSD8_25144F77626C";`

      If the device path does not exist on the machine being installed,
      update disko.nix before continuing.

   6. [Partition, format and mount the target disks.](https://github.com/nix-community/disko/blob/master/docs/quickstart.md#step-6-run-disko-to-partition-format-and-mount-your-disks)

      ```sh
      nix run \
         --extra-experimental-features "nix-command flakes" \
         github:nix-community/disko/latest -- \
         --mode destroy,format,mount \
         --flake .#nixos \
         --root-mountpoint /mnt \
         --yes-wipe-all-disks
      ```

   7. Install NixOS.

      ```sh
      nixos-install --root /mnt --flake .#nixos
      ```

   8. Set the user password.

      Replace `<username>` with the configured NixOS user name.

      ```sh
      nixos-enter --root /mnt -c "passwd <username>"
      ```

   9. Copy the repository into the installed system.

      This step is required because the Home Manager configuration uses
      out-of store symlinks that point to this repository.

      Replace `<username>` with the configured NixOS user name.

      ```sh
      mkdir -p "/mnt/home/<username>/Developer"
      cp -a . "/mnt/home/<username>/Developer/nix-config"
      nixos-enter --root /mnt -c "chown -R <username>:users /home/<username>/Developer/nix-config"
      ```

   10. Reboot into the installed system.

       ```sh
       reboot
       ```

       Remove the installation USB drive when the machine restarts.

### Daily Usage

- Build and apply NixOS system and Home Manager changes:

  ```sh
  just nixos
  ```

- Update flake inputs (dependencies):

  ```sh
  just nixos-update
  ```

## macOS

### Initial Setup

1. Install [Nix](https://nixos.org/download/#nix-install-macos):

   ```sh
   sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
   ```

2. Clone this repository:

   ```sh
   git clone https://github.com/chikuwasaurus/nix-config.git ~/Developer/nix-config
   cd ~/Developer/nix-config
   ```

3. Build and apply the [nix-darwin](https://github.com/nix-darwin/nix-darwin) configuration
(this will also install Homebrew automatically):

   ```sh
   sudo nix run \
       --extra-experimental-features "nix-command flakes" \
       nix-darwin/master#darwin-rebuild -- switch --flake .
   ```

4. Restart your machine

### Daily Usage

- Build and apply macOS system and Home Manager changes:

  ```sh
  just darwin
  ```

- Update flake inputs (dependencies):

  ```sh
  just darwin-update
  ```

## Linux (Apple container machine)

### Initial Setup

1. Create and Run machine:

   see: [nix-alpine](./containers/nix-alpine/README.md)

2. Apply dotfiles inside the container:

   ```sh
   nix run github:nix-community/home-manager -- switch --flake .#kyohei@apple-container
   ```

3. Restart your container machine

### Daily Usage

- Apply Home Manager changes inside Apple container:

   ```sh
   just container
   ```

### Note

Running Home Manager inside the container updates files
under the mounted host home directory.
