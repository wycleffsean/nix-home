# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./kakoune.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  xdg.enable = true;

  # TODO: Set your username
  home = {
    username = "sean";
    homeDirectory = "/home/sean";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    sessionVariables = {
        VISUAL = "kak";
    };
    stateVersion = "24.05";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.fzf = {
      enable = true;
      enableZshIntegration = true;
  };
  programs.git = {
      enable = true;
      # TODO: this stuff should not live in a shared home
      userEmail = "wycleffsean@gmail.com";
      userName = "Sean Carey";
  };
  programs.mcfly = {
      enable = true;
      enableZshIntegration = true;
      # fzf.enable = true; # TODO: this errors; best guess is a pkgs version issue
  };
  programs.nnn.enable = true;
  programs.ripgrep.enable = true;
  programs.starship = {
      enable = true;
      enableZshIntegration = true;
  };
  programs.zellij = {
      enable = true;
      enableZshIntegration = true;
  };
  programs.zsh = {
      enable = true;
      prezto.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # wayland.windowManager.river.enable = true;

}
