{ lib, pkgs, ... }:

let
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    variant = "macchiato";
    accents = [ "mauve" ];
    size = "standard";
    tweaks = [ ];
  };

  regreetSession = pkgs.writeShellScript "regreet-session" ''
    export XKB_DEFAULT_LAYOUT=fr

    export XCURSOR_THEME=Bibata-Modern-Ice
    export XCURSOR_SIZE=20

    export GTK_USE_PORTAL=0
    export GDK_DEBUG=no-portals

    exec ${pkgs.dbus}/bin/dbus-run-session \
      ${pkgs.cage}/bin/cage -s -d -- \
      ${pkgs.regreet}/bin/regreet
  '';
in
{
  services.greetd = {
    enable = true;

    settings.default_session = {
      command = "${regreetSession}";
      user = "greeter";
    };
  };

  services.displayManager.regreet = {
    enable = true;

    theme = {
      package = catppuccinGtk;
      name = "catppuccin-macchiato-mauve-standard";
    };

    font = {
      package = pkgs.nerd-fonts._0xproto;
      name = "0xProto Nerd Font";
      size = 16;
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

    settings = {
      skip_selection = true;

      background = {
        path = ../../home/spectre/assets/wallpapers/lockscreen/img4.png;
        fit = "Cover";
      };

      GTK.application_prefer_dark_theme = true;

      appearance.greeting_msg = "";

      # Make the hidden power actions harmless too.
      commands = {
        reboot = [ "${pkgs.coreutils}/bin/false" ];
        poweroff = [ "${pkgs.coreutils}/bin/false" ];
      };
    };

    extraCss = ''
      /* Hide ReGreet's reboot/poweroff buttons. */
      button.destructive-action {
        opacity: 0;
        min-width: 0;
        min-height: 0;
        padding: 0;
        margin: 0;
        border: none;
        font-size: 0;
      }
    '';
  };

  services.accounts-daemon.enable = true;

  # Login is password based.
  security.pam.services.greetd.fprintAuth = false;

  # Gnome keyring for apps like signal or proton auth.
  services.gnome.gnome-keyring.enable = true;

  security.pam.services.greetd.enableGnomeKeyring = true;
}
