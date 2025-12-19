{lib, ...}: {
  programs.rofi = lib.mkForce {
    enable = true;
    theme = ./../../preferences/rofi/type-6-9.rofi;
    location = "center";
  };
}
