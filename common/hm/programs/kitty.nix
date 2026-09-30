{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "CaskaydiaCove NF";
      size = 10;
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
    };
  };

  home.sessionVariables = {
    KITTY_LISTEN_ON = "unix:/tmp/kitty-juan";
  };
}
