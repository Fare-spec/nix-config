{ ... }:

{
  programs.kitty = {
    enable = true;

    shellIntegration.enableZshIntegration = true;

    font = {
      name = "0xProto Nerd Font Mono";
      size = 15;
    };

    themeFile = "Catppuccin-Macchiato";

    settings = {
      remember_window_position = "yes";
      background_opacity = 0.8;
      selection_foreground = "#CAD3F5";
      selection_background = "#939AB7";

      window_margin_width = 5;
      placement_strategy = "center";

      dynamic_background_opacity = "yes";

      copy_on_select = "yes";

      hide_window_decorations = "yes";

      enable_audio_bell = "no";

      visual_bell_duration = "1 ease-in-out";
      visual_bell_color = "#7a605b";

      scrollback_lines = 1000000;
      scrollback_pager_history_size = 512;
    };
  };
}
