{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [];

  services.jellyfin = {
      enable = true;
      openFirewall = true;
  };
  services.jellyseerr.enable = true;
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
