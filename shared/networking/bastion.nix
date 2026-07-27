{ ... }:
  {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "server";

      # Opens Tailscale's UDP listening port.  Tailscale can function
      # without this through relays, but permitting it improves the chance
      # of a p2p connection
      openFirewall = true;

      # This is the default Google Wifi LAN
      extraSetFlags = [
        "--advertise-routes=192.168.86.0/24"
      ];
    };

    # services.openssh = {
    #   enable = true;

    #   # TODO: revisit
    #   openFirewall = true;
    # };
  }
