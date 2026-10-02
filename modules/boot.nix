{ pkgs, ... }:

let
  nixosBlurTheme = pkgs.callPackage ../plymouth/nixos-blur-theme.nix { };
in
{

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
    editor = false;
    consoleMode = "auto";
  };

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
  boot.initrd.verbose = false;

  boot.resumeDevice = "/dev/disk/by-uuid/deed406f-9df5-4bda-8a1b-4f99984d10f6";

  boot.kernelParams = [
    "quiet"
    "loglevel=3"
    "rd.udev.log_level=3"
    "rd.systemd.show_status=auto"

    "resume_offset=17645568"
  ];
}
