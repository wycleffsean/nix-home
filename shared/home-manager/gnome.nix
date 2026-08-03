{
  config,
  pkgs,
  lib,
  ...
}:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  dconf.settings = lib.mkIf isLinux {
    "org/gnome/shell/keybindings" = {
      # Keep the notifications tray, but release
      # Super+V for applications
      toggle-message-tray = [ "<Super>m" ];
    };
  };
}
