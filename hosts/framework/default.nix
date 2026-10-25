{ inputs, ... }:

{

  swapDevices = [
    { device = "/swapfile"; }
  ];

  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ../../modules/users.nix
    ../../modules/boot.nix
    ../../modules/networking.nix
    ../../modules/audio.nix
    ../../modules/locale.nix
    ../../modules/nixpkgs.nix
    ../../modules/virtualisation.nix
    ../../modules/hardware.nix
    ../../modules/tools.nix
    ../../modules/gaming.nix
    ../../modules/network-tools.nix
    ../../modules/security.nix

    ../../modules/programs/obs.nix
    ../../modules/programs/development.nix

    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/thunar.nix
    ../../modules/desktop/login.nix

    ../../modules/services/bluetooth.nix
    ../../modules/services/misc.nix

  ];

  networking.hostName = "framework";
  hardware.framework.enableKmod = false; # Fix for a recent problem that made certificate require an extension I believe ? patch is on its way but the branch hasn't finished to build yet.
  networking.networkmanager.wifi.powersave = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
