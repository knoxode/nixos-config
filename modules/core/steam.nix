{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      extraPackages = [pkgs.gamescope pkgs.vulkan-hdr-layer-kwin6];
      extraCompatPackages = [pkgs.proton-ge-bin];
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
