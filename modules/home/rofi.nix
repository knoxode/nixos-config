{lib, ...}: {
  programs.rofi = lib.mkForce {
    enable = true;
    configPath = "~/.config/rofi/config.rasi";
    theme = ./../../preferences/rofi/type-6-9.rofi;
    location = "center";
  };
}
