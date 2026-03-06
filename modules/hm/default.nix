{ ... }:
{
  imports = [
    ./packages
    ./programs
    ./confs
  ];

  home.packages = [ ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "zen-beta.desktop" ];
      "x-scheme-handler/http" = [ "zen-beta.desktop" ];
      "x-scheme-handler/https" = [ "zen-beta.desktop" ];
      "x-scheme-handler/about" = [ "zen-beta.desktop" ];
      "x-scheme-handler/unknown" = [ "zen-beta.desktop" ];
    };
  };

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
      starship.enable = true;
      zsh.enable = true;
      zsh.configText = ''
      export PATH=$HOME/.local/bin:$PATH
      export PATH="/home/raz/.cache/.bun/bin:$PATH"
      export PATH="$PATH:$HOME/go/bin"
      #export ZK_NOTEBOOK_DIR="$HOME/vaults/codex-astartes/"
      
      #eval "$(zoxide init zsh)"
      eval "$(direnv hook zsh)"
      '';
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
