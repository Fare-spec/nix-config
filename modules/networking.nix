{ ... }:

{
  networking.networkmanager.enable = true;
  # networking.networkmanager.wifi.powersave = false;

  networking.firewall.allowedTCPPorts = [
    22000
  ];

  networking.firewall.allowedUDPPorts = [
    22000
    #    21027 syncthing local discovery
  ];
  networking.firewall.enable = true;

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # services.openssh.enable = true;
}
