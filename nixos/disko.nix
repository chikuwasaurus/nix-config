{
  disko.devices = {
    disk = {
      main = {
        type = "disk";

        # Prefer a stable /dev/disk/by-id path for normal operation.
        device = "/dev/disk/by-id/nvme-CT1000P3PSSD8_25144F77626C";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              priority = 1;
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
              priority = 2;
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
