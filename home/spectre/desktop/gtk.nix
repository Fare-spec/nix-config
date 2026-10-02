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
  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-macchiato-mauve-standard";
      package = catppuccinGtk;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
