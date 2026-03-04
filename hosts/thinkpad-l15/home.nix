{ pkgs, ... }: 
{
  hydenix.hm.theme.active = "Gruvbox Retro";

  home.file = {
    ".config/hypr/monitors.conf" = pkgs.lib.mkForce {
      source = ../../modules/hm/confs/hosts/thinkpad-l15/monitors.conf;
      force = true;
      mutable = false;
    };
  };
}
