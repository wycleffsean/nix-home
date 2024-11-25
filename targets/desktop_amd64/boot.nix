{ ... }:

{
  boot.loader = {
      efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
      };
      grub = {
          # despite what the configuration.nix manpage seems to indicate,
          # as of release 17.09, setting device to "nodev" will still call
          # `grub-install` if efiSupport is true
          # (the devices list is not used by the EFI grub install,
          # but must be set to some value in order to pass an assert in grub.nix)
          devices = [ "nodev" ];
          efiSupport = true;
          enable = true;
          # Only use OSProber when OSes are installed or changed. It takes forever to run
          # and is invoked on every rebuild.  Instead run it once, then copy the menu entries
          # out of /boot/grub/grub.cfg and add them to grub.extraEntries
          # see https://www.reddit.com/r/NixOS/comments/y033ny/comment/j4czz2k/
          # useOSProber = true;
          extraEntries = ''
            menuentry 'Arch Linux (on /dev/nvme0n1p4)' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-simple-0e966e8b-6d72-4bea-95c1-4683f769c6d7' {
            	insmod part_gpt
            	insmod ext2
            	search --no-floppy --fs-uuid --set=root 0e966e8b-6d72-4bea-95c1-4683f769c6d7
            	linux /boot/vmlinuz-linux root=/dev/nvme0n1p4
            	initrd /boot/initramfs-linux.img
            }
            submenu 'Advanced options for Arch Linux (on /dev/nvme0n1p4)' $menuentry_id_option 'osprober-gnulinux-advanced-0e966e8b-6d72-4bea-95c1-4683f769c6d7' {
            	menuentry 'Arch Linux (on /dev/nvme0n1p4)' --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-/boot/vmlinuz-linux--0e966e8b-6d72-4bea-95c1-4683f769c6d7' {
            		insmod part_gpt
            		insmod ext2
            		search --no-floppy --fs-uuid --set=root 0e966e8b-6d72-4bea-95c1-4683f769c6d7
            		linux /boot/vmlinuz-linux root=/dev/nvme0n1p4
            		initrd /boot/initramfs-linux.img
            	}
            }

            menuentry 'Windows Boot Manager (on /dev/nvme1n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-46D6-887C' {
            	insmod part_gpt
            	insmod fat
            	search --no-floppy --fs-uuid --set=root 46D6-887C
            	chainloader /EFI/Microsoft/Boot/bootmgfw.efi
            }
          '';
      };
  };
}
