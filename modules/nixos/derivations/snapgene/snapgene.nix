{ stdenv, fetchurl, rpm, cpio, qt6, kde5, fontconfig, nspr, expat, gcc, libcxx, dbus, krb5, libxkbcommon, xorg, nss, hicolor-icon-theme, openssl_1_1, zlib, libGLVND, openmp, makeWrapper, wrapQtAppsHook, autoPatchelfHook, xz, glibc, libxkbfile }:

stdenv.mkDerivation rec {
  pname = "snapgene";
  version = "8.0.1";
  src = fetchurl {
    url = "https://cdn.snapgene.com/downloads/SnapGene/8.x/8.0/${version}/${pname}_${version}_linux.rpm";
    sha256 = "10xqyrzybjy6dfgbzdhjyylm6xnwbqwccw1r1p1312j52cjydf32";
  };

  # Qt and other runtime dependencies
  nativeBuildInputs = [ rpm cpio autoPatchelfHook wrapQtAppsHook makeWrapper ];
  buildInputs = [
    qt6.qtbase qt6.qtwebchannel qt6.qt5compat qt6.qtdeclarative qt6.qtpositioning
    qt6.qtsvg qt6.qtwebengine kde5.qca xorg.libSM fontconfig nspr xz expat glibc gcc
    libcxx libcxx.rt dbus krb5 xorg.libxcb libxkbcommon xorg.xcbutil xorg.libx11 libxkbfile
    xorg.xcbutilkeysyms xorg.xcbutilrenderutil nss hicolor-icon-theme xorg.libICE
    libGLVND xorg.libXext openssl_1_1 zlib openmp
  ];

  # Extract RPM with rpm2cpio/ cpio
  unpackPhase = ''
    rpm2cpio $src | cpio -idmv
  '';
  installPhase = ''
    # Copy program files under $out
    mkdir -p $out/opt/gslbiotech/snapgene
    cp -r opt/gslbiotech/snapgene/* $out/opt/gslbiotech/snapgene/

    # Create a wrapper in $out/bin that sets LANG and QT_QPA_PLATFORM
    mkdir -p $out/bin
    wrapProgram "$out/opt/gslbiotech/snapgene/snapgene" \
      "$out/bin/snapgene" \
      --prefix PATH ":" "$coreutils/bin" \
      --set LANG "C.UTF-8" \
      --set QT_QPA_PLATFORM "wayland, xcb" \
      --run ShellHooks

    # Create a .desktop file with corrected Exec path
    mkdir -p $out/share/applications
    cat > $out/share/applications/snapgene.desktop <<EOF
[Desktop Entry]
Type=Application
Name=SnapGene
Comment=DNA plasmid mapping and primer design tool
Exec=$out/bin/snapgene %F
Icon=snapgene
Terminal=false
Categories=Science;Education;
EOF

    # Symlink license agreement
    mkdir -p $out/share/licenses/$pname
    ln -s $out/opt/gslbiotech/snapgene/resources/licenseAgreement.html \
          $out/share/licenses/$pname/LICENSE.html
  '';

  # Patch shebangs in any scripts (to use the wrapped shell)
  postPatch = ''
    find $out -type f -exec sed -i "1s|#! */bin/sh|#!${stdenv.shell}/bin/sh|" {} +
  '';

  # Metadata
  meta = with stdenv.lib; {
    description = "Software for plasmid mapping, primer design, and sequence analysis";
    homepage = "https://www.snapgene.com/";
    license = licenses.unfreeRedistributable;
    platforms = platforms.linux;
  };
}

