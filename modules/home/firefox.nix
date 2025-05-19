{ pkgs, ... }:

{
  # Enable Firefox
  programs.firefox = {
    enable = true;

    # Define a profile named 'shaiikura' with extensions
    profiles = {
      shaiikura = {
        id = 0;
        isDefault = true;
        extensions.packages = with pkgs; [
          nur.repos.rycee.firefox-addons.dashlane
          nur.repos.rycee.firefox-addons.ublock-origin
          nur.repos.rycee.firefox-addons.enhancer-for-youtube
          nur.repos.rycee.firefox-addons.darkreader
        ];
      };
      outlook = {
        id = 1;
        isDefault = false;
      };
    };
  };
}

