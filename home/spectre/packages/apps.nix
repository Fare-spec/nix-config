{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-calculator
    keepassxc
    libreoffice
    localsend
    proton-authenticator
    signal-desktop
    spotify
    tor-browser
    ungoogled-chromium
    vesktop
    warpinator
    servo
    orca-slicer
    ollama
  ];
}
