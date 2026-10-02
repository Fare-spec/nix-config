{
  stdenvNoCC,
  lib,
  fetchgit,
}:

stdenvNoCC.mkDerivation {
  pname = "nixos-blur-plymouth-theme";
  version = "1";

  src = fetchgit {
    url = "https://git.gurkan.in/gurkan/nixos-blur-plymouth.git";
    rev = "ea75b51a1f04aa914647a2929eab6bbe595bcfc0";
    hash = "sha256-BSmh+Gy3yJMA4RoJ0uaQ/WsYBs+Txr6K3cAQjf+yM5Y=";
  };

  installPhase = ''
    themeDir="$out/share/plymouth/themes/nixos-blur"
    mkdir -p "$themeDir"
    cp -r "$src/nixos-blur/"* "$themeDir/"

    substituteInPlace "$themeDir/nixos-blur.plymouth" \
      --replace "etc/plymouth/themes/nixos-blur" "$out/share/plymouth/themes/nixos-blur"
  '';

  meta.platforms = lib.platforms.linux;
}
