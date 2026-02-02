{pkgs, ...}: {
  programs = with pkgs; {
    wireshark = {
      enable = true;
      package = wireshark;
    };
  };
}
