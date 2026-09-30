{ pkgs, lib, ... }:
{
  programs.hyprland.enable = true; # provides start-hyprland (recommended launcher, Hyprland ≥0.53) + portals
  services.geoclue2.enable = true; # Required for QtPositioning (end-4 widgets)
  networking.networkmanager.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland xdg-desktop-portal-gtk ];
  };

  # Graphical greeter (shared): greetd + tuigreet launching Hyprland via the
  # recommended start-hyprland wrapper. greetd (not SDDM) sidesteps the
  # SDDM-Wayland problems mamalona already works around
  # (services.displayManager.sddm.wayland.enable = mkForce false).
  # The VFIO Windows-Gaming-VM specialisation on mamalona disables this
  # (see hosts/mamalona/configuration.nix) since the GPU is bound there.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-user-session --cmd start-hyprland";
        user = "greeter";
      };
    };
  };
}
