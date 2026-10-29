{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  kdePackages,
  llvmPackages,
  libcxx,
  libunwind,
  libxcb,
  xcbutil,
  libx11,
  libxkbfile,
  xcbutilkeysyms,
  xcbutilrenderutil,
  libice,
  libXcursor,
  libXext,
  openssl,
  xz,
  icu70,
  dbus,
}: let
  pname = "snapgene";
  version = "8.2.3";

  major = lib.versions.major version;
  majorMinor = lib.versions.majorMinor version;

  url = "https://cdn.snapgene.com/downloads/SnapGene/${major}.x/${majorMinor}/${version}/snapgene_${version}_linux.deb";

  sha256 = "093ml2mwa4w4mdxl1cjjhzaamiki2g44r9zaqiqqq4m9k1hlf2hp";

  appDir = "opt/gslbiotech/snapgene";
in
  stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      inherit url sha256;
    };

    nativeBuildInputs = [
      autoPatchelfHook
      kdePackages.wrapQtAppsHook
    ];

    buildInputs = [
      # Qt 6
      kdePackages.qtbase
      kdePackages.qtwebchannel
      kdePackages.qt5compat
      kdePackages.qtdeclarative
      kdePackages.qtpositioning
      kdePackages.qtsvg
      kdePackages.qtwebengine

      # X11 / XCB
      libxcb
      xcbutil
      libx11
      libxkbfile
      xcbutilkeysyms
      xcbutilrenderutil
      libice
      libXcursor
      libXext

      # Runtime libraries
      libcxx
      libunwind
      llvmPackages.openmp
      dbus
      openssl
      xz
      icu70
    ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack

      mkdir -p deb extract
      cd deb

      ar x "$src"

      cd ../extract
      tar -xf ../deb/data.tar.*

      # Prefer Nix-managed libraries over bundled copies.
      rm -f ${appDir}/libssl.so.3 \
            ${appDir}/libcrypto.so.3 \
            ${appDir}/liblzma.so.5 \
            ${appDir}/libicudata.so.70 \
            ${appDir}/libicui18n.so.70 \
            ${appDir}/libicuuc.so.70 \
            ${appDir}/libomp.so.5 \
            ${appDir}/libunwind.so.1

      runHook postUnpack
    '';

    patchPhase = ''
      runHook prePatch

      substituteInPlace usr/share/applications/snapgene.desktop \
        --replace-fail \
          "/opt/gslbiotech/snapgene/snapgene.sh" \
          "$out/${appDir}/snapgene" \
        --replace-fail \
          "/opt/gslbiotech/snapgene/launch.png" \
          "$out/${appDir}/launch.png"

      runHook postPatch
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"

      cp -r opt "$out/"
      cp -r usr/share "$out/share"

      chmod +x "$out/${appDir}/snapgene"

      # Compatibility names expected by bundled binaries.
      ln -s ${llvmPackages.openmp}/lib/libomp.so \
        "$out/${appDir}/libomp.so.5"

      ln -s ${libunwind}/lib/libunwind.so.8 \
        "$out/${appDir}/libunwind.so.1"

      # Ensure autoPatchelf can search the application directory.
      addAutoPatchelfSearchPath "$out/${appDir}"

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram "$out/${appDir}/snapgene" \
        --set QT_QPA_PLATFORM xcb
    '';

    meta = with lib; {
      description = "Molecular biology software for creating, editing and documenting DNA constructs";
      homepage = "https://www.snapgene.com";
      license = licenses.unfree;
      maintainers = [maintainers.knoxode];
      platforms = ["x86_64-linux"];
      mainProgram = "snapgene";
    };
  }
