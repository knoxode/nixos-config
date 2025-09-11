final: prev: {
  hyprpanel = prev.hyprpanel.overrideAttrs (old: rec {
    version = "auto-weather-on-master"; # whatever you prefer

    src = prev.fetchFromGitHub {
      owner = "knoxode";
      repo = "HyprPanel";
      # Use your branch or exact commit:
      rev = "automaticWeatherLocation";
      # First put lib.fakeHash to build once and get the real hash
      hash = "sha256-xoMK1WrTFIf97/P1ClMEA7Pru8/abJUMiuJ05wrCOpE=";
    };
  });
}
