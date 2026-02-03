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
  xorg,
  openssl_1_1,
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
      xorg.libxcb
      xorg.xcbutil
      xorg.libX11
      xorg.libxkbfile
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.libICE
      xorg.libXcursor
      xorg.libXext
      libcxx
      libtiff
      openssl_1_1
      dbus
      llvmPackages.openmp
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
        --set LD_LIBRARY_PATH "${lib.makeLibraryPath [openssl_1_1 libtiff]}:$LD_LIBRARY_PATH"
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
