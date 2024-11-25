{ pkgs, system, inputs, ... }:

let
  ags = inputs.ags;
in 

{
  devShells.${system}.default = pkgs.mkShell {
    buildInputs = [
      (ags.packages.${system}.default.override { 
        extraPackages = [
          inputs.ags.packages.${pkgs.system}.battery
          inputs.ags.packages.${pkgs.system}.auth
          inputs.ags.packages.${pkgs.system}.bluetooth
          # inputs.ags.packages.${pkgs.system}.cava
          inputs.ags.packages.${pkgs.system}.greet
          inputs.ags.packages.${pkgs.system}.hyprland
          inputs.ags.packages.${pkgs.system}.mpris
          inputs.ags.packages.${pkgs.system}.network
          inputs.ags.packages.${pkgs.system}.notifd
          inputs.ags.packages.${pkgs.system}.mpris
          inputs.ags.packages.${pkgs.system}.powerprofiles
          inputs.ags.packages.${pkgs.system}.tray
          inputs.ags.packages.${pkgs.system}.wireplumber
        ];
      })
    ];
  };
}
