# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  self,
  ...
}: {
  #imports =
  #  [ # Include the results of the hardware scan.
  #    ./hardware-configuration.nix
  #    <home-manager/nixos>
  #  ];
  imports = [
    #./hardware-configuration.nix
    #./boot.nix
    # Import home-manager's NixOS module
    #inputs.home-manager.nixosModules.home-manager

    #../../shared/std.nix
    ../../shared/packages/cli.nix
    #../../shared/users/sean.nix
    #../../shared/networking/mullvad.nix
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    #pkgs.kakoune
    pkgs.vim
    #          pkgs._1password-gui
  ];

  nix.enable = false; # Let Determinate Nix handle the Nix daemon/config

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  system.primaryUser = "sean";

  home-manager.users.sean.home.homeDirectory = pkgs.lib.mkForce "/Users/sean";

  environment.pathsToLink = ["/Applications"];

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
  homebrew = {
    enable = true;
    brews = [
      "kakoune"
      "gpg"
    ];
    casks = [
      "1password"
      "alfred"
      "daisydisk"
      "discord"
      "ghostty"
      "iina"
      #"viscosity"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Things 3" = 904280696;
      "WireGuard" = 1451685025;
    };
  };
}
