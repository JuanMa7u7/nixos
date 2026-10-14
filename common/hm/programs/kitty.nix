{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "CaskaydiaCove NF";
      size = 12;
    };
    settings = {
      term = "xterm-256color";
      scrollback_lines = 3000;
      background_opacity = "0.85";
      window_padding_width = 10;
      font_features = "CaskaydiaCoveNerdFont-Regular +liga +calt";

      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty-juan";
      
      background_blur = 0;
      dynamic_background_opacity = "yes";

      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_title_template = "🗿 {title}";
    };
    # end-4 dynamic Material colors: quickshell/matugen regenerates this file
    # on every wallpaper switch and SIGUSR1-reloads running kitties, so new
    # and live terminals follow the theme. First, like upstream's own config.
    # (If quickshell hasn't generated it yet, kitty logs a warning and starts.)
    extraConfig = ''
      include ~/.local/state/quickshell/user/generated/terminal/kitty-theme.conf
    '';
  };

  home.sessionVariables = {
    KITTY_LISTEN_ON = "unix:/tmp/kitty-juan";
  };
}
