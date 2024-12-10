# https://haseebmajid.dev/posts/2023-06-20-til-how-to-declaratively-setup-mullvad-with-nixos/
{pkgs, config, ...}: {
    environment.systemPackages = [ pkgs.mullvad-vpn pkgs.mullvad ];
    services.mullvad-vpn = {
        enable = true;
    };

    # This can also be set in the GUI
    systemd.services."mullvad-daemon".postStart = let
      mullvad = config.services.mullvad-vpn.package;
    in ''
      while ! ${mullvad}/bin/mullvad status >/dev/null; do sleep 1; done
      ${mullvad}/bin/mullvad auto-connect set on
      ${mullvad}/bin/mullvad tunnel set ipv6 on
      # Mullvad CLI now uses JSON for setting these values
      # but it's not exporting the current GUI settings
      # for some reason
      # ${mullvad}/bin/mullvad set default \
      #   --block-ads --block-trackers --block-malware
    '';
}
