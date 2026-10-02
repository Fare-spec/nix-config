{ pkgs, ... }:

{
  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      package = pkgs.qemu_kvm;

      swtpm.enable = true;

      vhostUserPackages = with pkgs; [
        virtiofsd
      ];
    };
  };

  virtualisation.docker.enable = true;
}
