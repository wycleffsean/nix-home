# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./kakoune.nix
  ];

  # nixpkgs = {
  #   # You can add overlays here
  #   overlays = [
  #     # If you want to use overlays exported from other flakes:
  #     # neovim-nightly-overlay.overlays.default

  #     # Or define it inline, for example:
  #     # (final: prev: {
  #     #   hi = final.hello.overrideAttrs (oldAttrs: {
  #     #     patches = [ ./change-hello-to-hi.patch ];
  #     #   });
  #     # })
  #   ];
  #   # Configure your nixpkgs instance
  #   config = {
  #     # Disable if you don't want unfree packages
  #     allowUnfree = true;
  #     # Workaround for https://github.com/nix-community/home-manager/issues/2942
  #     allowUnfreePredicate = _: true;
  #   };
  # };

  xdg.enable = true;
  xdg.mimeApps = lib.mkIf pkgs.stdenv.isLinux {
    enable = true;

    # super useful mime debugging technique
    # XDG_UTILS_DEBUG_LEVEL=2 xdg-mime query filetype foo.pdf
    # XDG_UTILS_DEBUG_LEVEL=2 xdg-mime query default application/pdf
    # fd evince.desktop /
    # see https://discourse.nixos.org/t/set-default-application-for-mime-type-with-home-manager/17190
    associations.added = {
      "video/mp4" = [
        "io.github.celluloid_player.Celluloid.desktop"
        "org.gnome.Totem.desktop"
      ];
    };
    defaultApplications = {
      "video/mp4" = [
        "io.github.celluloid_player.Celluloid.desktop"
        "org.gnome.Totem.desktop"
      ];
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];

    };
  };

  # TODO: Set your username
  home = {
    username = "sean";
    homeDirectory = lib.mkDefault (if pkgs.stdenv.isDarwin
                    then "/Users/sean"
                    else "/home/sean");
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    sessionVariables = {
      VISUAL = "kak";
    };
    stateVersion = "24.05";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = [
    inputs.zak.packages.${pkgs.system}.default
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.bat.enable = true;
  programs.difftastic = {
    enable = true;
    git.enable = true;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "wycleffsean@gmail.com";
        name = "Sean Carey";
      };
      pull.rebase = true;
      rerere.enabled = true;
      alias = {
        chekcout = "checkout";
        ignored = "ls-files -o -i --exclude-standard";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        filelog = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --numstat -u -- ";
        assume = "update-index --assume-unchanged";
        unassume = "update-index --no-assume-unchanged";
        assumed = "!git ls-files -v | grep ^h | cut -c 3-";
        unassumeall = "!git assumed | xargs git update-index --no-assume-unchanged";
      };
    };

    signing = {
      key = "779787E772A20366721609512AB4271E1454E6BD";
      # signByDefault = true;
    };

  };
  programs.htop = {
    enable = true;
  };
  programs.ledger = {
    enable = true;
    settings = {
      date-format = "%Y-%m-%d";
      file = [
        "~/code/accounting/personal/main.journal"
      ];
      sort = "date";
      # strict = true; # TODO!!!
    };
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
    enableZshIntegration = false;
  };
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd"
      "j"
    ];
  };
  programs.zsh = {
    enable = true;
    prezto.enable = true;
    initContent = ''
      eval "$(direnv hook zsh)"
    '';
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # wayland.windowManager.river.enable = true;

}
