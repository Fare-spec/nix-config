{ ... }:

{
  services.hyprpaper = {
    enable = true;

    settings = {
      splash = false;

      wallpaper = [
        {
          monitor = "";
          path = "${../assets/wallpapers/desktop}";
          fit_mode = "cover";

          order = "random";

          # Change wallpaper every 30 minutes.
          timeout = 300;
        }
      ];
    };
  };
}
