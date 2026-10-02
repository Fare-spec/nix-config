{ pkgs, ... }:

let
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    variant = "macchiato";
    accents = [ "mauve" ];
    size = "standard";
    tweaks = [ ];
  };
in
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 20;

    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-macchiato-mauve-standard";
      package = catppuccinGtk;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  };
}
