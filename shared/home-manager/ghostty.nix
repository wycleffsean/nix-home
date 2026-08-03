{ lib, pkgs, ... }:

let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in

{
  programs.ghostty = {
    enable = true;

    # Let home manager install ghostty on linux. on macos
    # use homebrew but still manage config
    package = if isLinux then pkgs.ghostty else null;

    systemd.enable = isLinux;

    settings = {
      scrollback-limit = 20000000;
    }
    // lib.optionalAttrs isLinux {
      keybind = [
        "performable:super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"
      ];
    };
  };
}
