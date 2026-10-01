{ ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports = [
    ./hardware-configuration.nix

  ];

  system.stateVersion = "25.11"; # Did you read the comment?
}

