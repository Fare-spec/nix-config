{ ... }:

{
  services.syncthing = {
    enable = true;

    # Keep devices/folders you add manually in the Web UI.
    overrideDevices = false;
    overrideFolders = false;
  };
}
