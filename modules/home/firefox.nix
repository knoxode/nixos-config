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
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          dashlane
          ublock-origin
          enhancer-for-youtube
          darkreader
        ];
      };
      outlook = {
        id = 1;
        isDefault = false;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          dashlane
          ublock-origin
          enhancer-for-youtube
          darkreader
        ];
      };
    };
  };
}

