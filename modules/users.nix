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
      "libvirtd"
      "kvm"
      "video"
      "wireshark"
    ];
  };
}
