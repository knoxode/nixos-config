{ pkgs, ... }:

{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    JAVA_HOME = "${pkgs.temurin-bin-17}";
  };
  environment.systemPackages = with pkgs; [ openrgb-with-all-plugins ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.docker = {
    enable = true;
  };
}
