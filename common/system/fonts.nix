{ pkgs, ... }:
{
  # The illogical-flake HM module already installs material-symbols (flake-built),
  # rubik, gabarito (NUR) and the full NerdFonts set into the user profile.
  # This system list mirrors the upstream README so greeters/TTY have coverage;
  # no nixpkgs material-symbols here by design.
  fonts.packages = with pkgs; [
    rubik
    nerd-fonts.ubuntu
    nerd-fonts.jetbrains-mono
  ];
}
