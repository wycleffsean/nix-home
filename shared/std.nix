# Standard base packages that aren't packaged with
# vanilla NixOS
{
  inputs,
  # outputs,
  # config,
  # lib,
  pkgs,
  ...
}:

{
  imports = [ ];

  # this gives <nixpkgs> the same pinned nixpkgs
  # input as the system flake; nixd recommends this
  # for flake-based systems
  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs}"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    file
  ];
}
