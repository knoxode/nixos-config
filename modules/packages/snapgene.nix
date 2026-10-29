{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  kdePackages,
  llvmPackages,
  libcxx,
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
  pname = "SnapGene";
  version = "8.2.3";
  major = lib.versions.major version;
  majorMinor = lib.versions.majorMinor version;

  url = "https://cdn.snapgene.com/downloads/SnapGene/${major}.x/${majorMinor}/${version}/snapgene_${version}_linux.deb";
  sha256 = "093ml2mwa4w4mdxl1cjjhzaamiki2g44r9zaqiqqq4m9k1hlf2hp";
in
  stdenv.mkDerivation {
    inherit pname version;
    src = fetchurl {
      inherit url sha256;
    };

    buildInputs = [
      kdePackages.qtbase
      kdePackages.qtwebchannel
      kdePackages.qt5compat
      kdePackages.qtdeclarative
      kdePackages.qtpositioning
      kdePackages.qtsvg
      kdePackages.qtwebengine
      libxcb
      xcbutil
      libx11
      libxkbfile
      xcbutilkeysyms
      xcbutilrenderutil
      libice
      libXcursor
      libXext
      libcxx
      libunwind
      dbus
      llvmPackages.openmp
      openssl
      xz
      icu70
    ];

    nativeBuildInputs = [
      kdePackages.wrapQtAppsHook
      autoPatchelfHook
    ];

    dontBuild = true;
    dontConfigure = true;

    unpackPhase = ''
      ar x $src
      mkdir -p extract
      cd extract
      # Usually 'data.tar.xz' or 'data.tar.gz' is present in .deb
      tar --extract --xz --file=../data.tar.xz
      # Strip the bundled OpenSSL 3, xz and ICU; autoPatchelf relinks against
      # the nixpkgs versions in buildInputs so security patches flow via
      # rebuilds.
      rm -f opt/gslbiotech/snapgene/libssl.so.3 \
            opt/gslbiotech/snapgene/libcrypto.so.3 \
            opt/gslbiotech/snapgene/liblzma.so.5 \
            opt/gslbiotech/snapgene/libicudata.so.70 \
            opt/gslbiotech/snapgene/libicui18n.so.70 \
            opt/gslbiotech/snapgene/libicuuc.so.70
    '';

    patchPhase = ''
      substituteInPlace usr/share/applications/snapgene.desktop \
        --replace "/opt/gslbiotech/snapgene/snapgene.sh" "$out/opt/gslbiotech/snapgene/snapgene" \
        --replace "/opt/gslbiotech/snapgene/launch.png" "$out/opt/gslbiotech/snapgene/launch.png"
    '';

    postFixup = ''
      wrapProgram $out/opt/gslbiotech/snapgene/snapgene \
        --set QT_QPA_PLATFORM xcb
    '';

    installPhase = ''
      mkdir -p $out
      cp -r opt $out/
      cp -r usr/share $out/share
      chmod +x $out/opt/gslbiotech/snapgene/snapgene
      # nixpkgs' LLVM 21 openmp ships unversioned libomp.so; provide the
      # libomp.so.5 soname the vendored binaries expect. Same for libunwind
      # (nixpkgs ships .so.8, vendored binaries want .so.1).
      ln -s ${llvmPackages.openmp}/lib/libomp.so \
            $out/opt/gslbiotech/snapgene/libomp.so.5
      ln -s ${libunwind}/lib/libunwind.so.8 \
            $out/opt/gslbiotech/snapgene/libunwind.so.1
    '';

    meta = with lib; {
      description = "Molecular biology software that allows researchers and labs to document DNA constructs in a shareable, electronic format";
      homepage = "https://www.snapgene.com";
      license = licenses.unfree;
      maintainers = [maintainers.knoxode];
      platforms = ["x86_64-linux"];
    };
  }
