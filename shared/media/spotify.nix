{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    spotify
  ];

  # Google Cast and so forth
  networking.firewall.allowedUDPPorts = [5353];
}
