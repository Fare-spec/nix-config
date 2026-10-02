{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Network inspection / diagnostics
    bind
    lls
    inetutils
    iw
    lynx
    mtr
    nmap
    traceroute
    wakeonlan
    w3m
    xh

    # Transfers / remote access
    httrack
    openconnect
    freerdp
    socat

    # Applications
    deluge
    proton-vpn

    # AMD monitoring
    radeontop
    nvtopPackages.amd
    rocmPackages.rocm-smi
  ];
}
