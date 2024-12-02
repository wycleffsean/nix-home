{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.kakoune = {
      enable = true;
      defaultEditor = true;
      config = {
        colorScheme = "snazzy";
      };
      plugins = with pkgs.kakounePlugins; [
          kakoune-lsp
          fzf-kak
      ];
      extraConfig = ''
        # in lieu of autoload
        # https://github.com/andreyorst/plug.kak/issues/83#issuecomment-864600718
        evaluate-commands %sh{
            config_files=$(find $kak_config/kakrc.d -name "*.kak")

            for file in $config_files; do
                printf "%s" "
                    try %{
                        source $file
                    } catch %{
                        echo -debug %{$file}
                        echo -debug %val{error}
                    }
                "
            done
        }
      '';
  };

  xdg.configFile = {
    "kak/colors/snazzy.kak".source = ../dotfiles/kak/colors/snazzy.kak;
    "kak/kakrc.d" = {
        recursive = true;
        source = ../dotfiles/kak/kakrc.d;
    };
  };
}
