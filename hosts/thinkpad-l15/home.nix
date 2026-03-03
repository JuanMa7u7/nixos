{ pkgs, ... }:
let
  pyamdgpuinfo = pkgs.python3Packages.pyamdgpuinfo or null;
  amdGpuPython =
    pkgs.lib.optional (pyamdgpuinfo != null)
      (pkgs.python3.withPackages (ps: [ ps.pyamdgpuinfo ]));
in
{
  hydenix.hm.theme.active = "Gruvbox Retro";

  home.packages = amdGpuPython;

  home.file = {
    ".config/hypr/monitors.conf" = pkgs.lib.mkForce {
      source = ../../modules/hm/confs/hosts/thinkpad-l15/monitors.conf;
      force = true;
      mutable = false;
    };

    ".local/lib/hyde/amdgpu.py" = pkgs.lib.mkForce {
      source = ../../modules/hm/confs/amdgpu.py;
      force = true;
      mutable = true;
    };
  };
}
