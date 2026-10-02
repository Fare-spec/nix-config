{ pkgs, ... }:

{
  home.packages = with pkgs; [
    asciiquarium
    bb
    cbonsai
    cmatrix
    cool-retro-term
    cowsay
    libcaca
    nyancat
    sl
    terminal-parrot
    terminal-rain-lightning
    tty-clock
  ];
}
