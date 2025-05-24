{ 
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  kdePackages,
  llvmPackages,
  libcxx,
  xorg,
  openssl_1_1,
  rpm,
  cpio,
}:

let
  sha256 = { "x86_64-linux" = "1bzfm7rzb5xzwzdl63ahmrngqay2d17968apazqwxpq0v1y1ms1y"; }."${stdenv.system}";

in
stdenv.mkDerivation rec {
  pname = "snapgene";
  version = "8.0.3";
  versionMajor = "8";
  versionMiddle = "0";
  versionMinor = "3";

  src = fetchurl {
    url = "https://cdn.snapgene.com/downloads/SnapGene/${versionMajor}.x/${versionMajor}.${versionMiddle}/${version}/snapgene_${version}_linux.rpm";
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
    openssl_1_1
    openssl_1_1.dev
    llvmPackages.openmp
  ];

  nativeBuildInputs = [
    kdePackages.wrapQtAppsHook
    cpio
    rpm
    autoPatchelfHook
  ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    rpm2cpio $src | cpio -idmv
  '';

  patchPhase = ''
    # Fix up .desktop file
    substituteInPlace usr/share/applications/snapgene.desktop \
      --replace "/opt/gslbiotech/snapgene/snapgene.sh" "$out/opt/gslbiotech/snapgene/snapgene" \
      --replace "/opt/gslbiotech/snapgene/launch.png" "$out/opt/gslbiotech/snapgene/launch.png"
  '';

  postFixup = ''
    wrapProgram $out/opt/gslbiotech/snapgene/snapgene \
      --set QT_QPA_PLATFORM xcb \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ openssl_1_1 ]}:$LD_LIBRARY_PATH"
  '';

  installPhase = ''
    mkdir -p $out/usr/bin
    cp -r opt usr $out/
    mv $out/usr/share $out/share
    chmod +x $out/opt/gslbiotech/snapgene/snapgene
  '';

  meta = with lib; {
    description = "Molecular biology software that allows researchers and labs to document DNA constructs in an a shareable, electronic format";
    homepage = "www.snapgene.com";
    license = licenses.unfree;
    maintainers = [ maintainers.knoxode ];
    platforms = [ "x86_64-linux" ];
  };
}
