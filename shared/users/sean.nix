{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [];

  users.users.sean = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
        # Sean Arch id_rsa in 1P
        ''
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHVThrW02iZpLh6+XE4id7KYRyDj7poa2MOjtRF+jVSXPVOtmVJ2wWue3OnaEaiSL23UQ7bcMh6lB82cvTsbE0uDhKKk1n0GasELyzrlNSLDJMNrGG+vVQJb/Ft99HabL5Al3TlAMCMUGgFTsbC9ug3efx0Ce7J+WUTl6VPGsa4JGYIz7/1kVvyPMXlM5tqQmOwC+F4Dylj7Obrpe0T3BHFLZ9ZLIzyRkdgSphT5AzxVZXH1khpFiY7TPd6uYfioJgkBtFeiFWn5Tf2zY8XE25Ckhu/fgOhZSkVcl2QGM4cpma3u+bmh6DOKz7l3HEsLKMp7xWwwxVAHNShvDXXRJ7l1sqF3p+QicFBjO+dcTUgMddrbz0ZHcX7Cgmz4pfMfx5om7LssYN2GwBWnyhmVUnTqBNWgc+/F2H1dfeRERpo9KwVZb3S+wiwN1LK2qRhpr/PpL+VXddUCqL7BrjLK9epa2+9Cs324ChM9wEhVvkLE2WZSiTULmRnOreL9CZm0k=
        ''
    ];
  };

  home-manager = {
      extraSpecialArgs = { inherit inputs outputs; };
      users = {
          sean = import ../home-manager/home.nix;
      };
  };
}
