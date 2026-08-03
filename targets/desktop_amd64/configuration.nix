# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  #imports =
  #  [ # Include the results of the hardware scan.
  #    ./hardware-configuration.nix
  #    <home-manager/nixos>
  #  ];
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
    ./zfs.nix
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager

    ../../shared/std.nix
    ../../shared/packages/cli.nix
    ../../shared/desktop/niri.nix
    ../../shared/desktop/gnome.nix
    ../../shared/users/sean.nix
    ../../shared/networking/mullvad.nix
    ../../shared/media/spotify.nix
  ];

  # Avoid getty racing / interfering with GDM on the first VT
  # i.e. blank screen with cursor after login (with GDM + Wayland)
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  #### This is the stuff we will copy into git

  services.netatalk = {
    enable = true;
    settings = {
      Homes = {
        "basedir regex" = "/home";
      };
      crypt.path = "/run/media/sean/home/sean/crypt/stuff";
      foxcroft.path = "/foxcroft";
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

  services.samba = {
    enable = true;
    settings = {
      "crypt" = {
        path = "/run/media/sean/home/sean/crypt/stuff";
        # browseable = "yes";
        # writable = "no";
        # "guest ok" = "no";
        # "read only" = "yes";
      };
      "foxcroft" = {
        path = "/foxcroft";
        # browseable = "yes";
        # writable = "no";
        # "guest ok" = "no";
        # "read only" = "yes";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
  #   package = pkgs-unstable.ollama;
  #   # home = "/home/sean"; # otherwise it writes to /var/lib/ollama/.ollama
  #   # user can't read /home/sean
  #   # but we needed it (instead of DynamicUser) so
  #   # we could set fs perms for the zfs dataset
  #   # user = "ollama";
  #   # just made this chmod -R 777 so
  #   # we don't have to deal with all of the headaches
  #   models = "/foxcroft/ai_models/ollama";
  #   environmentVariables = {
  #     # https://docs.ollama.com/context-length
  #     # this is a stretch on our vram budget
  #     # but also basically necessary for coding agents
  #     OLLAMA_CONTEXT_LENGTH = "64000";
  #   };
  #   loadModels = [
  #     # "qwen3-coder:latest" # 19GB
  #     # "glm-4.7-flash:latest" # 19GB
  #   ];
  # };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "sean" ];

    authentication = pkgs.lib.mkOverride 10 ''
      #...
      #type database DBuser origin-address auth-method
      local all       all     trust
      # ipv4
      host  all      all     127.0.0.1/32   trust
      # ipv6
      host all       all     ::1/128        trust
    '';

    identMap = ''
      # ArbitraryMapName systemUser DBUser
         superuser_map      root      postgres
         superuser_map      postgres  postgres
         superuser_map      sean  postgres
         # Let other names login as themselves
         superuser_map      /^(.*)$   \1
    '';
  };

  services.udisks2 = {
    enable = true;
    # zfs.enable = true;
  };

  services.hardware.openrgb = {
    enable = true;
    # package = pkgs.openrgb-with-all-plugins;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "sean" ];
  };
  programs.coolercontrol.enable = true;
  programs.dconf.enable = true; # for gtk/qt apps like duckstation
  programs.nix-ld.enable = true;
  programs.zsh.enable = true;

  home-manager.users.sean =
    { pkgs, ... }:
    {
      home.packages = [ ];
      programs.zsh.enable = true;

      programs.ssh = {
        enable = true;
        extraConfig = ''
          Host *
          	IdentityAgent SSH_AUTH_SOCK
          Host macbook-pro
            Hostname MacBook-Pro.local
            User sean
            PubkeyAuthentication unbound
            IdentitiesOnly no
        '';
      };

      programs.git = {
        enable = true;
        # TODO: gpg signing with 1Password. See nixos 1password wiki
      };

      # The state version is required and should stay at the version you originally installed
      home.stateVersion = "24.05";
    };

  fileSystems."/run/media/sean/home" = {
    device = "/dev/disk/by-uuid/dc64c413-9903-4d41-9495-89814665bb14";
    fsType = "ext4";
  };

  #### END COPY

  # Bootloader.
  #boot.loader.grub.enable = true;
  #boot.loader.grub.device = "nodev";
  #boot.loader.grub.useOSProber = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # https://github.com/ollama/ollama/issues/3931#issuecomment-2623391542
  # networking.nameservers = [
  #   "8.8.8.8"
  #   "8.8.4.4"
  # ];

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
  services.displayManager.gdm = {
    enable = true;
    # wayland = true; # required for Niri sessions
  };
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  hardware.nvidia-container-toolkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sean = {
    isNormalUser = true;
    description = "Sean Carey";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  # TODO: set unfree predicates instead i.e. explicitly list unfree software
  nixpkgs.config = {
    allowUnfree = true;
    # cudaSupport = true; # causes blender/suitesparse ptxas segfault; dev shell manages CUDA libs directly
    permittedInsecurePackages = [
      "ventoy-1.1.05"
      "mbedtls-2.28.10"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # blender -- use flatpak or `nix run nixpkgs#blender` (system pkg triggers cudaSupport ptxas segfault in 26.05)
    bottles
    cargo
    celluloid
    claude-code
    codex
    # coolercontrol.coolercontrol-gui
    # coolercontrol.coolercontrold
    # coolercontrol.coolercontrol-liqctld
    # coolercontrol.coolercontrol-ui-data
    # devilutionx
    discord
    doctl
    # duckstation # PS1 Emulator
    encfs
    gamemode # for lutris
    gamescope # for lutris
    gcc
    gdb
    gnumake
    godot_4
    httpie-desktop
    ladybird
    libreoffice
    lsof
    lutris # game preservation platform
    man-pages
    man-pages-posix
    mangohud # for lutris
    pkg-config
    protonplus # needed for battle.net on lutris
    ruby
    rustc
    # rustdesk # remote desktop -- build broken in 26.05 (cargo vendor fetches from github at build time)
    socat
    typescript
    # ungoogled-chromium
    # ventoy-full
    vscode-langservers-extracted
    xclip
    xeyes
    #  wget
  ];

  # Enable docker
  # we've also added 'sean' to the 'docker' group
  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    # ports = [ 5432 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "sean" ];
      X11Forwarding = true;
      X11UseLocalhost = true;
    };
  };
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h";
      overalljails = true;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    #Samba
    139 # NetBIOS
    445 # SMB

    548 # netatalk
    1234 # openra
  ];
  networking.firewall.allowedUDPPorts = [
  ]
  ++ pkgs.lib.lists.range 60000 61000; # mosh
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # https://nixos.wiki/wiki/Samba#Firewall_configuration
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
