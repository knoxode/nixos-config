{
  config,
  lib,
  inputs,
  ...
}: let
  hyprlandOverlay = inputs.hyprland.overlays.default;
  hyprlockOverlay = inputs.hyprlock.overlays.default;
in {
  options.hyprOnMain = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkIf config.hyprOnMain {
    nixpkgs.overlays = [hyprlockOverlay hyprlandOverlay];
  };
}
