{ config, pkgs, inputs, system, ... }:

{
  # Install firefox.
  programs.firefox = {
    enable = true;
  };
}
