{pkgs, ...}: {
  # Only enable either docker or podman -- Not both
  virtualisation = {
    libvirtd.enable = false;
    docker.enable = true;
    podman.enable = false;
  };
  environment.systemPackages = with pkgs; [
    docker-compose
    # distrobox
    # virt-viewer # View Virtual Machines
  ];
}
