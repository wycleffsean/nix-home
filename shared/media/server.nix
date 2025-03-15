{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [];

  # Firewall settings to allow HTTP access
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Enable Glances with Web UI
  services.glances = {
    enable = true;
    webUI = {
      enable = true;
      port = 61208;
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
