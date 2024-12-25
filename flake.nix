{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Nix Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Ghostty
    ghostty.url = "git+ssh://git@github.com/ghostty-org/ghostty";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ghostty,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    #
    # Give specific host names - generic hostnames like "nixos"
    # plus 'nixos-rebuild --flake .' can lead to mistakes
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
            ./targets/desktop_amd64/configuration.nix
            {
                environment.systemPackages = [ ghostty.packages.x86_64-linux.default ];
            }
        ];
      };

      "nixos-vm" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [./targets/qemu_kvm/configuration.nix];
      };

      raspberrypi4 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [./targets/rpi4/configuration.nix];
      };
    };

    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MacBook-Pro
    # or nix run nix-darwin -- switch --flake ~/.config/nix-darwin

    # 13" 2020 M1 machine
    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit self inputs outputs;};
      modules = [ ./targets/macbook_pro/configuration.nix ];
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "sean@sean-Arch" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./shared/home-manager/home.nix];
      };

      "sean@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./shared/home-manager/home.nix];
      };

      "sean@raspberrypi4" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./shared/home-manager/home.nix];
      };
    };
  };
}
