{ inputs, outputs, config, lib, pkgs, ... }:

let
  staticKeys = [
    # Sean Arch id_rsa in 1P
    ''
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDHVThrW02iZpLh6+XE4id7KYRyDj7poa2MOjtRF+jVSXPVOtmVJ2wWue3OnaEaiSL23UQ7bcMh6lB82cvTsbE0uDhKKk1n0GasELyzrlNSLDJMNrGG+vVQJb/Ft99HabL5Al3TlAMCMUGgFTsbC9ug3efx0Ce7J+WUTl6VPGsa4JGYIz7/1kVvyPMXlM5tqQmOwC+F4Dylj7Obrpe0T3BHFLZ9ZLIzyRkdgSphT5AzxVZXH1khpFiY7TPd6uYfioJgkBtFeiFWn5Tf2zY8XE25Ckhu/fgOhZSkVcl2QGM4cpma3u+bmh6DOKz7l3HEsLKMp7xWwwxVAHNShvDXXRJ7l1sqF3p+QicFBjO+dcTUgMddrbz0ZHcX7Cgmz4pfMfx5om7LssYN2GwBWnyhmVUnTqBNWgc+/F2H1dfeRERpo9KwVZb3S+wiwN1LK2qRhpr/PpL+VXddUCqL7BrjLK9epa2+9Cs324ChM9wEhVvkLE2WZSiTULmRnOreL9CZm0k=
    ''
  ];
  githubKeysPath = builtins.fetchurl {
    url = "https://github.com/wycleffsean.keys";
    sha256 = "1p6699k94phwnsh04q97yk6cp4hccirgjpbz4snihy8apkiy145f";
  };
  githubKeysRaw = builtins.readFile githubKeysPath;
  githubKeys = builtins.filter (k: k != "") (pkgs.lib.strings.splitString "\n" githubKeysRaw);
  addIfMissing = key: acc: if builtins.elem key acc then acc else acc ++ [ key ];
  combineUnique = list:
    let
      recur = xs: acc:
       if xs == [] then acc else recur (builtins.tail xs) (addIfMissing (builtins.head xs) acc);
    in
      recur list [];
  authorizedKeys = combineUnique (staticKeys ++ githubKeys);
in

{
  imports = [];

  users.users.sean = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "media" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = authorizedKeys;
  };

  home-manager = {
      extraSpecialArgs = { inherit inputs outputs; };
      users = {
          sean = import ../home-manager/home.nix;
      };
  };

  systemd.user.services.encfs-cleanup = {
    description = "Unmount all encfs FUSE filesystems on logout";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "oneshot";
      # We just need it to "exist" during the session so ExecStop runs on logout
      ExecStart = "${pkgs.coreutils}/bin/true";

      # On stop (logout), unmount every fuse.encfs mount for this user
      ExecStop = ''
        ${pkgs.bash}/bin/bash -lc '
          # Find all encfs mounts (type fuse.encfs) owned by this user and unmount them
          ${pkgs.util-linux}/bin/findmnt -t fuse.encfs -n -o TARGET --raw \
            | while read -r m; do
                echo "encfs-cleanup: unmounting $m"
                ${pkgs.fuse}/bin/fusermount -u "$m" || true
              done
        '
      '';
    };
  };
}
