{pkgs, ...}: {
  programs = {
    gamescope = {
      enable = false;
      capSysNice = false;
    };
  };
}
