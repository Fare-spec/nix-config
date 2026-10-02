{ config, pkgs, ... }:

let
  wallpapers = ../assets/wallpapers/lockscreen;

  currentWallpaper = "${config.xdg.cacheHome}/hyprlock-wallpaper.png";

  randomHyprlock = pkgs.writeShellScriptBin "hyprlock-random" ''
    set -eu

    mkdir -p "${config.xdg.cacheHome}"

    wallpaper="$(
      ${pkgs.findutils}/bin/find ${wallpapers} \
        -maxdepth 1 \
        -type f \
        -iname '*.png' \
        -print |
      ${pkgs.coreutils}/bin/shuf -n 1
    )"

    if [ -z "$wallpaper" ]; then
      echo "No lockscreen wallpapers found." >&2
      exit 1
    fi

    ln -sfn "$wallpaper" "${currentWallpaper}"

    exec ${pkgs.hyprlock}/bin/hyprlock
  '';
in
{
  home.packages = [
    randomHyprlock
  ];

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = [
        {
          monitor = "";
          path = currentWallpaper;

          blur_passes = 3;
          blur_size = 8;

          color = "rgb(36, 39, 58)";
        }
      ];

      label = [
        {
          monitor = "";
          text = "$USER";
          color = "rgb(165, 173, 203)";
          font_size = 18;
          font_family = "0xProto Nerd Font";
          position = "0, -10";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          monitor = "";

          size = "280, 55";
          position = "0, -80";

          dots_center = true;
          fade_on_empty = false;

          outline_thickness = 0;

          inner_color = "rgba(36, 39, 58, 0.90)";
          font_color = "rgb(202, 211, 245)";

          font_family = "0xProto Nerd Font";
          placeholder_text = "Password...";

          rounding = 12;
        }
      ];
    };
  };
}
