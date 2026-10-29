{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];
  stylix = {
    enable = true;
    # targets = {
    #   plymouth.enable = false;
    # };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # Deliberately no `image`: the palette comes entirely from base16Scheme,
    # and no active target consumes one (GRUB defaults to a solid base00
    # background — targets.grub.useWallpaper is false since Stylix 25.05).
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
    cursor = {
      # bibata-cursors ships all 12 variants (~320 MiB); wrap it so only the
      # single theme stylix actually uses ends up in the closure.
      package = pkgs.runCommand "bibata-cursors-modern-ice" { } ''
        mkdir -p $out/share/icons
        cp -r ${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice $out/share/icons/
      '';
      name = "Bibata-Modern-Ice";
      size = 24;
    };
  };
}
