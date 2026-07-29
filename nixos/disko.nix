{
  disko.devices = {
    disk = {
      main = {
        type = "disk";

        # Prefer a stable /dev/disk/by-id path for normal operation.
        # disko-install can override this with:
        #   --disk main /dev/nvme0n1
        device = "/dev/disk/by-id/nvme-CT1000P3PSSD8_25144F77626C";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";

                mountOptions = [ "umask=0077" ];
              };
            };

            root = {
              size = "100%";

              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
