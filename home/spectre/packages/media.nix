{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Creation / editing
    blender
    gimp
    gnome-sound-recorder
    kdePackages.kdenlive
    krita

    # Media utilities
    ffmpeg
    oxipng

    # Players
    vlc
  ];
}
