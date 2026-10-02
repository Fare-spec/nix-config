{ pkgs, ... }:

{
  home.packages = with pkgs; [
    grim
    slurp
    pavucontrol
    brightnessctl
    imv
    playerctl
    hyprpolkitagent
  ];
}
