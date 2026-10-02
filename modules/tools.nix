{ pkgs, ... }:

{
  programs.bandwhich.enable = true;

  services.locate.enable = true;

  environment.systemPackages = with pkgs; [

    libguestfs
    efibootmgr
    libinput
    lshw
    parted
    powertop
    smartmontools
    usbutils
    kmon
    btop
    lm_sensors
    tcpdump
  ];
}
