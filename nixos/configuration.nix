# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Import home-manager's NixOS module
      inputs.home-manager.nixosModules.home-manager
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sean = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
        # Sean Arch id_rsa in 1P
        ''
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHVThrW02iZpLh6+XE4id7KYRyDj7poa2MOjtRF+jVSXPVOtmVJ2wWue3OnaEaiSL23UQ7bcMh6lB82cvTsbE0uDhKKk1n0GasELyzrlNSLDJMNrGG+vVQJb/Ft99HabL5Al3TlAMCMUGgFTsbC9ug3efx0Ce7J+WUTl6VPGsa4JGYIz7/1kVvyPMXlM5tqQmOwC+F4Dylj7Obrpe0T3BHFLZ9ZLIzyRkdgSphT5AzxVZXH1khpFiY7TPd6uYfioJgkBtFeiFWn5Tf2zY8XE25Ckhu/fgOhZSkVcl2QGM4cpma3u+bmh6DOKz7l3HEsLKMp7xWwwxVAHNShvDXXRJ7l1sqF3p+QicFBjO+dcTUgMddrbz0ZHcX7Cgmz4pfMfx5om7LssYN2GwBWnyhmVUnTqBNWgc+/F2H1dfeRERpo9KwVZb3S+wiwN1LK2qRhpr/PpL+VXddUCqL7BrjLK9epa2+9Cs324ChM9wEhVvkLE2WZSiTULmRnOreL9CZm0k=
        ''
    ];
  };

  home-manager = {
      extraSpecialArgs = { inherit inputs outputs; };
      users = {
          sean = import ../home-manager/home.nix;
      };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
environment.systemPackages = with pkgs; [
  neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  kakoune
  wget
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

