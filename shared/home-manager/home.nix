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
  xdg.mimeApps = {
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
    };
  };

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
  home.packages = [
    inputs.zak.packages.${pkgs.system}.default
  ];


  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.bat.enable = true;
  programs.fzf = {
      enable = true;
      enableZshIntegration = true;
  };
  programs.git = {
      enable = true;
      # TODO: this stuff should not live in a shared home
      userEmail = "wycleffsean@gmail.com";
      userName = "Sean Carey";

      difftastic.enable = true;

      aliases = {
	chekcout = "checkout";
	ignored = "ls-files -o -i --exclude-standard";
	lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
	filelog = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --numstat -u -- ";
	assume = "update-index --assume-unchanged";
	unassume = "update-index --no-assume-unchanged";
	assumed = "!git ls-files -v | grep ^h | cut -c 3-";
	unassumeall = "!git assumed | xargs git update-index --no-assume-unchanged";
      };

      extraConfig = {
          pull.rebase = true;
          rerere.enabled = true;
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
      enableZshIntegration = true;
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
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # wayland.windowManager.river.enable = true;

}
