{ inputs, outputs, config, lib, pkgs, ... }:

let
  nixpkgs-24_11 = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-24.11.tar.gz") { system = pkgs.stdenv.hostPlatform.system; };
in
{
  imports = [];

  # Firewall settings to allow HTTP access
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Enable Glances with Web UI
  # 24.11 only
  # services.glances = {
  #   enable = true;
  #   webUI = {
  #     enable = true;
  #     port = 61208;
  #   };
  # };

  # Pull in Glances from NixOS 24.11
  systemd.services.glances = {
    description = "Glances system monitoring";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${nixpkgs-24_11.glances}/bin/glances -w";
      Restart = "always";
    };
  };

  services.jellyfin = {
      enable = true;
      openFirewall = true;
  };
  services.jellyseerr.enable = true;

  services.nginx = {
    enable = true;
    virtualHosts = {
      "raspberrypi4.local" = {
        root = "${builtins.toString ../static}";
        index = "index.html";

        # Proxy Jellyfin
        locations."/jellyfin/" = {
          proxyPass = "http://localhost:8096/";
          proxyWebsockets = true;
        };

        # Proxy Glances Web UI
        locations."/diag/" = {
          proxyPass = "http://localhost:61208/";
        };      };
    };
  };

  environment.systemPackages = with pkgs; [
      jellyfin
      jellyfin-web
      jellyfin-ffmpeg
  ];

  # Create a media group and assign jellyfin user to it
  users.groups.media = { gid = 1004; };
  users = {
      users.jellyfin = {
          extraGroups = [ "media" ];
      };
  };

}
