{ pkgs, ... }:

{
  # Enable Firefox
  programs.firefox = {
    enable = true;

    # Define a profile named 'shaiikura' with extensions
    profiles.shaiikura = {
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        dashlane
        ublock-origin
        enhancer-for-youtube
        darkreader
      ];
    };
  };
}

