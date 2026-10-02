{ ... }:

{
  imports = [
    ./programs/zsh.nix
    ./programs/cli.nix
    ./programs/git.nix
    ./programs/neovim.nix
    ./programs/rofi.nix
    ./programs/mangohud.nix
    ./programs/media.nix
    ./programs/firefox.nix
    ./programs/kitty.nix

    ./packages/desktop.nix
    ./packages/cli.nix
    ./packages/apps.nix
    ./packages/dev.nix
    ./packages/gaming.nix
    ./packages/media.nix
    ./packages/network.nix
    ./packages/fun.nix
    ./packages/security.nix

    ./desktop/hyprland.nix
    ./desktop/hyprlock.nix
    ./desktop/hyprpaper.nix
    ./desktop/gtk.nix
    ./desktop/waybar.nix
    ./desktop/mako.nix

    ./services/polkit.nix
    ./services/syncthing.nix
    ./services/clipboard.nix
  ];
  home.stateVersion = "26.05";
}
