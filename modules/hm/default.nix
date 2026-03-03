{ ... }:
{
  imports = [
    ./packages
    ./programs
    ./confs
  ];

  home.packages = [ ];

  hydenix.hm = {
    enable = true;
    comma.enable = true;
    dolphin.enable = true;
    editors = {
      enable = true;
      vscode = {
        enable = false;
        wallbash = true;
      };
      default = "nvim";
    };
    fastfetch.enable = true;
    firefox = {
      enable = true;
    };
    git = {
      enable = true;
      name = "JuanMa7u7";
      email = "jmlafuente97@gmail.com";
    };
    hyde.enable = true;
    hyprland.enable = true;
    lockscreen = {
      enable = true;
      hyprlock = true;
      swaylock = false;
    };
    notifications.enable = true;
    qt.enable = true;
    rofi.enable = true;
    screenshots = {
      enable = true;
      grim.enable = true;
      slurp.enable = true;
      satty.enable = true;
      swappy.enable = false;
    };
    shell = {
      enable = true;
      zsh.enable = true;
      bash.enable = false;
      fish.enable = false;
      pokego.enable = false;
    };
    spotify.enable = false;
    swww.enable = false;
    terminals = {
      enable = true;
      kitty.enable = true;
      kitty.configText = ''
        allow_remote_control yes
      '';
    };
    theme = {
      enable = true;
      themes = [
        # "Catppuccin Mocha"
        # "Rose Pine"
        # "Red Stone"
        # "Vanta Black"
        # "Cosmic Blue"
        "Scarlet Night"
        # "Ever Blushing"
        # "Another World"
        # "Bad Blood"
        # "Cat Latte"
        # "Graphite Mono"
        "Gruvbox Retro"
        # "Monokai"
        # "Moonlight"
        # "Tokyo Night"
        # "Sci fi"
        # "Solarized Dark"
      ];
    };
    waybar.enable = true;
    wlogout.enable = true;
    xdg.enable = true;
  };
}
