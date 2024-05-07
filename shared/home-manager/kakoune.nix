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
      config = {
        colorScheme = "snazzy";
      };
      plugins = with pkgs.kakounePlugins; [
          kak-lsp
          kak-fzf
          kak-powerline
      ];
      extraConfig = ''
        # Use ripgrep instead of grep
        set-option global grepcmd 'rg -Hn --no-heading'

        # in lieu of autoload
        # https://github.com/andreyorst/plug.kak/issues/83#issuecomment-864600718
        evaluate-commands %sh{
            config_files="
                rspec.kak
                ide.kak
                keybinds.kak
            "

            for file in $config_files; do
                printf "%s" "
                    try %{
                        source %{''${kak_config:?}/$file}
                    } catch %{
                        echo -debug %val{error}
                    }
                "
            done
        }
      '';
  };

  xdg.configFile = {

    "kak/colors/snazzy.kak".source = ../dotfiles/kak/colors/snazzy.kak;
    "kak/rspec.kak".source = ../dotfiles/kak/rspec.kak;
    "kak/ide.kak".source = ../dotfiles/kak/ide.kak;
    "kak/keybinds.kak".source = ../dotfiles/kak/keybinds.kak;
  };
}
