# home/spectre/packages/security.nix
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    burpsuite
  ];
}
