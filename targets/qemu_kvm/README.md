# Setup

Using QEMU/KVM + libvirt + virtmanager + edk2-ovmf (for UEFI support).

Create host utilizing UEFI.  When installing NixOS be sure to add a swap partition.

The `hardware-configuration.nix` file in this repo should work because we utilize labels instead of uuids, but for help with alignment of filestystems and disks utilize this command:

```
lsblk -o name,mountpoint,partlabel,label,size,uuid
```
