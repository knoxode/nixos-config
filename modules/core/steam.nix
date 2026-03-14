{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      gamescopeSession.enable = true;
      extraPackages = [];
      extraCompatPackages = [pkgs.proton-ge-bin];
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
