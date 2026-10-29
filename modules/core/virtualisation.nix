{pkgs, ...}: {
  # Only enable either docker or podman -- Not both
  virtualisation = {
    libvirtd.enable = false;
    docker.enable = true;
    # Socket-activated on first docker command instead of idling a daemon at
    # boot on hosts with no containers.
    docker.enableOnBoot = false;
    podman.enable = false;
  };
  environment.systemPackages = with pkgs; [
    docker-compose
    # distrobox
    # virt-viewer # View Virtual Machines
  ];
}
