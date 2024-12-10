{
  description = "Nix flake for the SnapGene software";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "openssl-1.1.1w" ];
      };
    };
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation rec {
      pname = "snapgene";
      version = "8.0.1";
      _pkgver_major = "8";
      _pkgver_major_middle = "8.0";

      src = pkgs.fetchurl {
        url = "https://cdn.snapgene.com/downloads/SnapGene/${_pkgver_major}.x/${_pkgver_major_middle}/${version}/${pname}_${version}_linux.rpm";
        sha256 = "10xqyrzybjy6dfgbzdhjyylm6xnwbqwccw1r1p1312j52cjydf32";
      };

      nativeBuildInputs = [
        pkgs.rpm
        pkgs.autoPatchelfHook
        pkgs.makeWrapper
        pkgs.kdePackages.wrapQtAppsHook
        pkgs.cpio
      ];

      buildInputs = with pkgs; [
        qt6.qtbase
        qt6.qtwebchannel
        qt6.qt5compat
        qt6.qtdeclarative
        qt6.qtpositioning
        qt6.qtsvg
        qt6.qtwebengine
        kdePackages.qca  # or kdeFrameworks.qca if kdeApplications.qca is unavailable
        xorg.libSM
        fontconfig
        nspr
        xz
        expat
        glibc
        gcc
        libcxx
        libcxxrt
        dbus
        krb5
        xorg.libxcb
        libxkbcommon
        xorg.xcbutil
        xorg.libX11
        xorg.libxkbfile
        xorg.xcbutilkeysyms
        xorg.xcbutilrenderutil
        nss
        hicolor-icon-theme
        xorg.libICE
        libglvnd
        xorg.libXext
        openssl_1_1  # Requires explicit permission due to being insecure
        zlib
        llvmPackages.openmp
      ];

      # Ensure autoPatchelfHook can find the binaries
      autoPatchelfIgnoreMissingDeps = true;

      unpackPhase = ''
        rpm2cpio $src | cpio -idmv
      '';

      installPhase = ''
        mkdir -p $out/opt/gslbiotech/snapgene
        cp -r opt/gslbiotech/snapgene/* $out/opt/gslbiotech/snapgene/

        # Create symlink to license
        mkdir -p $out/share/licenses/$pname
        ln -s $out/opt/gslbiotech/snapgene/resources/licenseAgreement.html \
          $out/share/licenses/$pname/LICENSE.html

        patchelf --set-rpath "${pkgs.openssl_1_1}/lib:${placeholder "out"}/opt/gslbiotech/snapgene" \
          $out/opt/gslbiotech/snapgene/tls/libqopensslbackend.so
        patchelf --set-rpath "${pkgs.openssl_1_1}/lib:${placeholder "out"}/opt/gslbiotech/snapgene" \
          $out/opt/gslbiotech/snapgene/snapgene
      '';

      meta = with pkgs.lib; {
        description = "Software for plasmid mapping, primer design, and restriction site analysis";
        homepage = "https://www.snapgene.com/about";
        license = licenses.unfreeRedistributable;
        maintainers = [];
        platforms = platforms.linux;
      };
    };
  };
}

