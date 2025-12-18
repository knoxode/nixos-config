{
  inputs,
  pkgs,
  ...
}: {
  # Enable Firefox
  programs.firefox = {
    enable = true;
    package = inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin;

    profiles = {
      kuchikopi = {
        name = "kuchikopi";
        id = 0;
        isDefault = true;
        extensions.packages = with pkgs; [
          nur.repos.rycee.firefox-addons.dashlane
          nur.repos.rycee.firefox-addons.ublock-origin
          nur.repos.rycee.firefox-addons.enhancer-for-youtube
          nur.repos.rycee.firefox-addons.darkreader
          nur.repos.rycee.firefox-addons.tabliss
        ];
      };
    };
  };
}
