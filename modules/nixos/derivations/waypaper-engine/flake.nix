{
  description = "Nix flake for the Waypaper-Engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation rec {
      pname = "waypaper-engine";
      version = "2.0.3";

      src = pkgs.fetchFromGitHub {
        owner = "0bCdian";
        repo = "Waypaper-Engine";
        rev = "v${version}";
        sha256 = "sha256-DIVrfTqPsvNFvzvjzP80VBgubUqnqTw9xX0ZhhJYBZM="; # Replace with actual hash
      };

      buildInputs = [
        pkgs.nodejs
        pkgs.socat
        pkgs.fzf
        pkgs.jq
        pkgs.wlr-randr
        pkgs.hicolor-icon-theme
      ];

      buildPhase = ''
        mkdir -p build
        cp -r ./* ./build
        cd build
        npm install --prefix .
        npm run build
      '';

      installPhase = ''
        mkdir -p $out/usr/bin
        mkdir -p $out/opt/${pname}
        mkdir -p $out/usr/share/{applications,icons/hicolor,licenses}

        # Install the CLI
        install -Dm755 ./cli/waypaper-engine $out/usr/bin/${pname}

        # Install icons
        for size in 16x16 32x32 64x64 128x128 256x256 512x512; do
          install -Dm644 "./release/linux-unpacked/resources/icons/$(placeholder "size").png" \
            "$out/usr/share/icons/hicolor/$(placeholder "size"")/apps/${pname}.png"
        done

        # Install .desktop file
        install -Dm644 ./waypaper-engine.desktop $out/usr/share/applications/${pname}.desktop

        # Install LICENSE
        install -Dm644 ./LICENSE $out/usr/share/licenses/${pname}/LICENSE

        # Copy other unpacked files to /opt
        cp -r ./release/linux-unpacked/* $out/opt/${pname}/
      '';

      meta = with pkgs.lib; {
        description = "A pleasant GUI frontend for swww with batteries included!";
        homepage = "https://github.com/0bCdian/Waypaper-Engine";
        license = licenses.gpl3Plus;
        maintainers = [ ];
        platforms = platforms.linux;
      };
    };
  };
}

