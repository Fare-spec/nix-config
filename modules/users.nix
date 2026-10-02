{ pkgs, ... }:

{
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  users.users.spectre = {
    isNormalUser = true;
    description = "spectre";

    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "libvirtd"
      "kvm"
      "video"
      "wireshark"
    ];
  };
}
