# Standard base packages that aren't packaged with
# vanilla NixOS
{ inputs, outputs, config, lib, pkgs, ... }:

{
  imports = [];

  environment.systemPackages = with pkgs; [
      file
  ];
}
