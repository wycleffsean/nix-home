# This file is just for installing gnome specific
# packages.  We'd really rather update home-manager
# but some packages don't appear there
{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # TODO: should this just be in home manager?
  #   it didn't appear in man 5 home-configuration.nix
  environment.systemPackages = with pkgs; [
    gnomeExtensions.copyous
  ];
}
