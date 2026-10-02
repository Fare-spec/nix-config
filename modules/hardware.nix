{ pkgs, ... }:

{
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  services.udev.packages = [
    pkgs.brightnessctl
  ];

  environment.etc."libinput/local-overrides.quirks".text = ''
    [SINOWEALTH Game Mouse drag clicking]
    MatchName=SINOWEALTH Game Mouse
    ModelBouncingKeys=1
  '';
}
