{ pkgs, ... }:

{
  programs.nix-ld.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.jdk21;
  };
}
