{ config, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;
    settings = {
      terminal = "kitty";
      font = "0xProto Nerd Font 14";

      modi = "drun,run";
      show-icons = true;

      disable-history = false;
      max-history-size = 100;

      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";

      drun-match-fields = "name,keywords";
      drun-display-format = "{name}";
    };
    theme = {
      "*" = {
        bg = mkLiteral "#24273a";
        surface = mkLiteral "#363a4f";
        text = mkLiteral "#cad3f5";
        subtext = mkLiteral "#a5adcb";
        mauve = mkLiteral "#c6a0f6";

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@text";
      };

      window = {
        width = mkLiteral "40%";
        border = 0;
        border-radius = mkLiteral "12px";
        background-color = mkLiteral "@bg";
        padding = mkLiteral "12px";
      };

      mainbox = {
        spacing = mkLiteral "10px";
        background-color = mkLiteral "transparent";
      };

      inputbar = {
        padding = mkLiteral "10px";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@surface";
        text-color = mkLiteral "@text";
        children = [
          "prompt"
          "entry"
        ];
      };

      prompt = {
        text-color = mkLiteral "@mauve";
      };

      entry = {
        placeholder = "Search…";
        placeholder-color = mkLiteral "@subtext";
      };

      listview = {
        lines = 8;
        columns = 1;
        spacing = mkLiteral "4px";
        background-color = mkLiteral "transparent";
      };

      element = {
        padding = mkLiteral "8px";
        border-radius = mkLiteral "8px";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@text";
      };

      "element selected" = {
        background-color = mkLiteral "@surface";
        text-color = mkLiteral "@mauve";
      };

      element-icon = {
        size = mkLiteral "24px";
        margin = mkLiteral "0 10px 0 0";
      };

      element-text = {
        vertical-align = mkLiteral "0.5";
      };
    };
  };
}
