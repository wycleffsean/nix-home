{
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  #### Niri compositor (Wayland session)
  programs.niri.enable = true;

  #### “Keep GNOME-like services, but not GNOME Shell”
  programs.dconf.enable = true; # you already have this, fine to keep here too

  # Keyring + polkit are the “feels like a desktop” glue.
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  #### Portals (needed for screensharing, file pickers, flatpak-ish stuff, etc.)
  xdg.portal = {
    enable = true;
    # GTK portal works well for file dialogs etc.
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  #### Networking + Bluetooth UIs (GNOME backends still work fine)
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    # quickfinder/launcher
    fuzzel

    # notifications
    mako

    # tray applets / “GNOME-ish” toggles
    networkmanagerapplet

    # screenshots + region select
    grim
    slurp

    # clipboard history (nice with fuzzel)
    wl-clipboard
    cliphist

    # optional: bar (start here even if you want QS later)
    waybar

    # optional: power menu
    wlogout

    xwayland-satellite
  ];

  #### Recommended: make sure common Wayland env vars are sane
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # helps Electron/Chromium apps use Wayland
  };

  #### (Optional) If you want the user session to reliably have a tray,
  #### Waybar is the lowest-friction “it just works” starting point.
  #### You can migrate to Quickshell after you’re stable.
}
