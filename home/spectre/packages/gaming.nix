{ pkgs, ... }:

{
  home.packages = with pkgs; [
    _2048-in-terminal
    constrict
    cubiomes-viewer
    ldtk
    linuxwave
    prismlauncher
    tetris
    vulkan-tools
    waywall
    xclicker
    pawn-appetit
  ];
}
