# Raspberry Pi 4 Setup

## Image Generation

[NixOS-Generators](https://github.com/nix-community/nixos-generators)

We want to be able to load an image onto an SD Card, plug into the network, and be able to access the host via SSH.  No HDMI, or keyboard or whatever.  We can generate an image ourselves with our own `configuration.nix` to load directly onto the pi.

### Requirements

- A NixOS Host with [`boot.binfmt.emulatedSystems = [ "aarch64-linux" ];`](https://github.com/nix-community/nixos-generators)
- an SD Card Reader/Writer

## Considering Bootstrapping via PXE
- [Raspberry Pi PXE Boot](https://linuxhit.com/raspberry-pi-pxe-boot-netbooting-a-pi-4-without-an-sd-card/#0-what-does-this-raspberry-pi-pxe-boot-tutorial-cover)
- [PXE Server on Arch](https://wiki.archlinux.org/title/Preboot_Execution_Environment#Server_setup)
- [NixOS 1: ZFS Encrypted Root on Thinkpad P51](https://www.youtube.com/watch?v=CboOUrkIZ2k)
