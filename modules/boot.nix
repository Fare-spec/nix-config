{ pkgs, lib, ... }:

let
  nixosBlurTheme = pkgs.callPackage ../plymouth/nixos-blur-theme.nix { };
in
{
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.extraModprobeConfig = "
  options mt7921e disable_aspm=1
  ";

  #  options mt7921_common disable_clc=1

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.consoleMode = "auto";

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  boot.plymouth = {
    enable = true;
    theme = "nixos-blur";
    themePackages = [
      nixosBlurTheme
    ];
  };

  boot.consoleLogLevel = 3;

  boot.resumeDevice = "/dev/disk/by-uuid/deed406f-9df5-4bda-8a1b-4f99984d10f6";

  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.udev.log_level=3"
    "rd.systemd.show_status=auto"

    "resume_offset=17645568"
  ];
}
