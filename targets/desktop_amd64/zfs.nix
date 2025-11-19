{ config, pkgs, ...}:

{
  # Enable ZFS support
  boot.supportedFilesystems = [ "zfs" ];
  # Used to avoid importing pools on the wrong machine
  networking.hostId = "007f0200";
  # boot.zfs.extraPools = [ "foxcroft" ]; # we don't want to depend on a USB device at boot because sometimes it's off
  # boot.zfs.devScan = true;

  services.zfs.autoScrub.enable = true; # weekly
  # services.zfs.trim.enable = true; # our drives are not SSDs
  services.zfs.autoSnapshot = {
    enable = true;
    frequent = 8; # keep last ~8 hourly-ish snapshots
    daily = 7;
    weekly = 4;
    monthly = 3;
  };
}
