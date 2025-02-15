# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ghostty, ... }:

{
  #imports =
  #  [ # Include the results of the hardware scan.
  #    ./hardware-configuration.nix
  #    <home-manager/nixos>
  #  ];
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
      # Import home-manager's NixOS module
      inputs.home-manager.nixosModules.home-manager

      ../../shared/std.nix
      ../../shared/users/sean.nix
      ../../shared/networking/mullvad.nix
    ];

  #### This is the stuff we will copy into git

  services.netatalk = {
      enable = true;
      settings = {
          Homes = {
              "basedir regex" = "/home";
          };
          crypt.path = "/run/media/sean/home/sean/crypt/stuff";
      };
  };
  services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
          enable = true;
          userServices = true;
      };
      extraServiceFiles = {
          afp = ''
            <?xml version="1.0" standalone="no"?>
            <!DOCTYPE service-group SYSTEM "avahi-service.dtd">

            <service-group>
                <name replace-wildcards="yes">%h</name>

                <service>
                    <type>_device-info._tcp</type>
                    <port>0</port>
                    <txt-record>model=Xserve</txt-record>
                </service>
            </service-group>
          '';
          afpd = ''
            <?xml version="1.0" standalone="no"?>
            <!DOCTYPE service-group SYSTEM "avahi-service.dtd">

            <service-group>
                <name replace-wildcards="yes">%h</name>

                <service>
                    <type>_device-info._tcp</type>
                    <port>0</port>
                    <txt-record>model=Xserve</txt-record>
                </service>
            </service-group>
          '';
      };
  };

  programs._1password.enable = true;
  programs._1password-gui = {
      enable = true;
      # Certain features, including CLI integration and system authentication support,
      # require enabling PolKit integration on some desktop environments (e.g. Plasma).
      polkitPolicyOwners = [ "sean" ];
  };
  programs.zsh.enable = true;

  home-manager.users.sean = { pkgs, ...}: {
     home.packages = [];
     programs.zsh.enable = true;

     programs.ssh = {
         enable = true;
         extraConfig = ''
         Host *
         	IdentityAgent ~/.1password/agent.sock
         '';
     };

     programs.git = {
         enable = true;
         # TODO: gpg signing with 1Password. See nixos 1password wiki
     };

     # The state version is required and should stay at the version you originally installed
     home.stateVersion = "24.05";
  };

  fileSystems."/run/media/sean/home" =
    { device = "/dev/disk/by-uuid/dc64c413-9903-4d41-9495-89814665bb14";
      fsType = "ext4";
    };

  #### END COPY

  # Bootloader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "nodev";
  #boot.loader.grub.useOSProber = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sean = {
    isNormalUser = true;
    description = "Sean Carey";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  # TODO: set unfree predicates instead i.e. explicitly list unfree software
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   celluloid
   discord
   encfs
   kakoune # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
   ventoy-full
   xclip
  #  wget
  ];
  # ] ++ [ ghostty ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
      548 # netatalk
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
