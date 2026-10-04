{ pkgs, ... }:
let
  signalLibsecret = pkgs.writeShellApplication {
    name = "signal-desktop-libsecret";

    text = ''
      exec ${pkgs.signal-desktop}/bin/signal-desktop \
        --password-store=gnome-libsecret "$@"
    '';
  };
in
{
  home.packages = with pkgs; [
    gnome-calculator
    keepassxc
    libreoffice
    localsend
    proton-authenticator
    signal-desktop
    signalLibsecret
    spotify
    tor-browser
    ungoogled-chromium
    vesktop
    warpinator
    servo
    orca-slicer
    ollama
  ];
  xdg.desktopEntries.signal = {
    name = "Signal";
    genericName = "Private Messenger";

    exec = "${signalLibsecret}/bin/signal-desktop-libsecret %U";

    icon = "signal-desktop";
    terminal = false;

    categories = [
      "Network"
      "InstantMessaging"
    ];
    mimeType = [
      "x-scheme-handler/sgnl"
    ];
  };
}
