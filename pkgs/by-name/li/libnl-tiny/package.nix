{
  stdenv,
  lib,
  fetchgit,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "libnl-tiny";
  version = "unstable-2023-12-05";

  src = fetchgit {
    url = "https://git.openwrt.org/project/libnl-tiny.git";
    rev = "965c4bf49658342ced0bd6e7cb069571b4a1ddff";
    hash = "sha256-kegTV7FXMERW7vjRZo/Xp4cbSBZmynBgge2lK71Fx94=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  preConfigure = ''
    sed -e 's|''${prefix}/@CMAKE_INSTALL_LIBDIR@|@CMAKE_INSTALL_FULL_LIBDIR@|g' \
        -e 's|''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@|@CMAKE_INSTALL_FULL_INCLUDEDIR@|g' \
        -i libnl-tiny.pc.in
  '';

  meta = with lib; {
    description = "Tiny OpenWrt fork of libnl";
    homepage = "https://git.openwrt.org/?p=project/libnl-tiny.git;a=summary";
    license = licenses.isc;
    maintainers = with maintainers; [ mkg20001 ];
    platforms = platforms.linux;
  };
}
