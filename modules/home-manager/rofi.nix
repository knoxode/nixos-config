{ lib, ... }:

{
  programs.rofi = lib.mkForce {
    enable = true;
    configPath = "/home/shaiikura/.config/rofi/config.rasi";
    theme = ./../../preferences/rofi/type-6-9.rofi;
    location = "center";
  };
}

