{
  programs.television = {
    enable = true;
    channels = {
      nix = {
        cable_channel = [
          {
            name = "nixpkgs";
            source_command = "nix-search-tv print";
            preview_command = "nix-search-tv preview {}";
          }
        ];
      };
    };
    enableFishIntegration = true;
    enableBashIntegration = true;
  };
}
