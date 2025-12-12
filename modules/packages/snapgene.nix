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
  #To obtain this string, obtain via nix-prefetch-url followed by the URL in quotes
  sha256 =
    {
      "x86_64-linux" = "1waf4czq0ck104w3w2y0gargkra6iwfy1jir0y9riha6pg1zsryb";
    }."${stdenv.hostPlatform.system}";
in
  stdenv.mkDerivation rec {
    pname = "snapgene";
    version = "8.2.0";
    versionMajor = "8";
    versionMiddle = "2";
    versionMinor = "0";

    src = fetchurl {
      url = "https://cdn.snapgene.com/downloads/SnapGene/${versionMajor}.x/${versionMajor}.${versionMiddle}/${version}/snapgene_${version}_linux.deb";
      inherit sha256;
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
