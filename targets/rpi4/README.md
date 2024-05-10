# Raspberry Pi 4

## Setup (from MacOS host)

1. Download the [SD image from Hydra](https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux)
1. ...uncompress
1. Insert SD Card into macbook
1. `diskutil list` to determine the disk to use (probably the last one)
1. something like this `dd if=nixos.sd_image.aarch64.img of=/dev/disk7 bs=4096`
  - MacOS `dd` is different than linux, there is no fsync option. Just setting block size works IIRC

## TODO

- [ ] change hostname
- [ ] Add nixos-hardware channel (from wiki)
- [ ] Enable GPU Support
- [ ] `libraspberrypi` package
- [ ] `gpio` group so non-root users can use GPIO
- [ ] Enable SPI
- [ ] Enable HDMI-CEC

## Resources

 - [NixOS Wiki][nix_rpi4_wiki]

## Administration

### Mesaure Tempurature and CPU Frequency

Use `vcgencmd`, included in `libraspberrypi`

### Upgrading U-Boot/Firmware (bootloader)

Upgrading should also enable USB boot.  From [wiki][nix_rpi4_wiki]:

```sh
nix-shell -p raspberrypi-eeprom
sudo mount /dev/disk/by-label/FIRMWARE /mnt
sudo BOOTFS=/mnt FIRMWARE_RELEASE_STATUS=stable rpi-eeprom-update -d -a
```

## Future - alternative bootstrapping

### Image Generation

[NixOS-Generators](https://github.com/nix-community/nixos-generators)

We want to be able to load an image onto an SD Card, plug into the network, and be able to access the host via SSH.  No HDMI, or keyboard or whatever.  We can generate an image ourselves with our own `configuration.nix` to load directly onto the pi.

#### Requirements

- A NixOS Host with [`boot.binfmt.emulatedSystems = [ "aarch64-linux" ];`](https://github.com/nix-community/nixos-generators)
- an SD Card Reader/Writer

## Considering Bootstrapping via PXE
- [Raspberry Pi PXE Boot](https://linuxhit.com/raspberry-pi-pxe-boot-netbooting-a-pi-4-without-an-sd-card/#0-what-does-this-raspberry-pi-pxe-boot-tutorial-cover)
- [PXE Server on Arch](https://wiki.archlinux.org/title/Preboot_Execution_Environment#Server_setup)
- [NixOS 1: ZFS Encrypted Root on Thinkpad P51](https://www.youtube.com/watch?v=CboOUrkIZ2k)


nix_rpi4_wiki: https://wiki.nixos.org/wiki/NixOS_on_ARM/Raspberry_Pi_4
