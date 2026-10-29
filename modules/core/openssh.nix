{
  services.openssh = {
    enable = true;
    settings = {
      # Key-only: both users' ed25519 keys are declared in user.nix.
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      # Wayland host; X forwarding over SSH serves nothing.
      X11Forwarding = false;
    };
    openFirewall = true;
  };
}
