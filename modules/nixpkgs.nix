{  ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Temporary workaround for an unstable systemd-boot regression:
  # copy-extra-files is being created as 0444 instead of executable.
  nixpkgs.overlays = [
    (final: prev: {
      writeShellScript =
        name: text:
        if name == "copy-extra-files" then
          let
            source = prev.writeText "${name}-source" ''
              #!${prev.runtimeShell}
              ${text}
            '';
          in
          prev.runCommand name { } ''
            cp ${source} "$out"
            chmod 0555 "$out"
          ''
        else
          prev.writeShellScript name text;
    })
  ];
}
