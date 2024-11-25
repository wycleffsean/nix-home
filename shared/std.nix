# Standard base packages that aren't packaged with
# vanilla NixOS
{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
      file
  ];
}
