{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.spicetify-nix.nixosModules.spicetify];
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
  in
    lib.mkForce {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      theme = spicePkgs.themes.starryNight;
      colorScheme = "Base";
    };
}
