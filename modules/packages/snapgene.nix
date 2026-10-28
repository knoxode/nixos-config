{
  binutils,
  lib,
  libtiff,
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
  dbus,
}: let
  pname = "SnapGene";
  version = "8.2.2";
  versionList = lib.versions.splitVersion version;
  major = builtins.elemAt versionList 0;
  majorMinor = lib.versions.majorMinor version;
  # patch = builtins.elemAt versionList 2;

  url = "https://cdn.snapgene.com/downloads/SnapGene/${major}.x/${majorMinor}/${version}/snapgene_${version}_linux.deb";
  name = builtins.concatStringsSep "-" [pname version];
  sha256 =
    {
      "x86_64-linux" = "1nfw1mrgmi4a95w2qf6c2c0mk8dz6kxlyl44inmzvdd89ybi91wp";
    }."${stdenv.hostPlatform.system}";
in
  stdenv.mkDerivation {
    inherit name pname version;
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
      libtiff
      dbus
      llvmPackages.openmp
      openssl
      xz
    ];

    nativeBuildInputs = [
      binutils
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
      # Strip the bundled OpenSSL 3 and xz; autoPatchelf relinks against the
      # nixpkgs versions in buildInputs so security patches flow via rebuilds.
      rm -f opt/gslbiotech/snapgene/libssl.so.3 \
            opt/gslbiotech/snapgene/libcrypto.so.3 \
            opt/gslbiotech/snapgene/liblzma.so.5
    '';

    patchPhase = ''
      substituteInPlace usr/share/applications/snapgene.desktop \
        --replace "/opt/gslbiotech/snapgene/snapgene.sh" "$out/opt/gslbiotech/snapgene/snapgene" \
        --replace "/opt/gslbiotech/snapgene/launch.png" "$out/opt/gslbiotech/snapgene/launch.png"
    '';

    preFixup = ''
      # The only object that still asks for libtiff.so.5
      patchelf --replace-needed \
               libtiff.so.5 libtiff.so \
               $out/opt/gslbiotech/snapgene/imageformats/libqtiff.so
    '';

    postFixup = ''
      wrapProgram $out/opt/gslbiotech/snapgene/snapgene \
        --set QT_QPA_PLATFORM xcb \
        --set LD_LIBRARY_PATH "${lib.makeLibraryPath [libtiff]}:$LD_LIBRARY_PATH"
    '';

    installPhase = ''
      mkdir -p $out/usr/bin
      cp -r opt usr $out/
      mv $out/usr/share $out/share
      chmod +x $out/opt/gslbiotech/snapgene/snapgene
    '';

    meta = with lib; {
      description = "Molecular biology software that allows researchers and labs to document DNA constructs in a shareable, electronic format";
      homepage = "https://www.snapgene.com";
      license = licenses.unfree;
      maintainers = [maintainers.knoxode];
      platforms = ["x86_64-linux"];
    };
  }
