{ ... }:

{
  services.greetd.enable = true;

  programs.regreet = {
    enable = true;

    settings = {
      skip_selection = true;

      background = {
        path = ../../home/spectre/assets/wallpapers/lockscreen/img4.png;
        fit = "Cover";
      };

      GTK = {
        application_prefer_dark_theme = true;
        font_name = "0xProto Nerd Font 16";
      };

      appearance = {
        greeting_msg = "Welcome back fool";
      };
    };
  };

  services.accounts-daemon.enable = true;

  security.pam.services.greetd.fprintAuth = false;
}
