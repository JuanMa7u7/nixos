{ ... }:
{

  # hydenix home-manager options go here
  hydenix.hm = {
    #! Important options
    enable = false;
    comma.enable = true; # useful nix tool to run software without installing it first
    dolphin.enable = true; # file manager
    editors = {
      enable = false; # enable editors module
      # neovim.enable = true; # enable neovim module
      vscode = {
        enable = false; # enable vscode module
        wallbash = true; # enable wallbash extension for vscode
      };
      # vim.enable = true; # enable vim module
      default = "nvim"; # default text editor
    };
    fastfetch.enable = false; # fastfetch configuration
    git = {
      enable = false; # enable git module
      name = "JuanMa7u7"; # git user name eg "John Doe"
      email = "jmlafuente97@gmail.com"; # git user email eg "john.doe@example.com"
     };
    hyde.enable = false;
    hyprland.enable = false;
    lockscreen = {
      enable = false; # enable lockscreen module
      hyprlock = false; # enable hyprlock lockscreen
      swaylock = false; # enable swaylock lockscreen
    };
    screenshots = {
      enable = true; # enable screenshots module
      grim.enable = true; # enable grim screenshot tool
      slurp.enable = true; # enable slurp region selection tool
    };
    shell = {
      enable = false;
      zsh.enable = false;
      starship.enable = false;
      bash.enable = false;
      fish.enable = false;
      pokego.enable = false;
    };
    terminals = {
      enable = false;
      kitty.enable = false;
    };
    spotify.enable = true; # enable spotify module
  };
}
