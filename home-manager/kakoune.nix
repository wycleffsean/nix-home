# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # Enable home-manager and git
  programs.kakoune = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs; [
          kak-lsp
          kak-fzf
          kak-powerline
      ];
      extraConfig = ''
      '';
  };
}
