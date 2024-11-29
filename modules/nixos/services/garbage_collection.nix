{
  # Automatically run garbage collection weekly
  nix.gc = {
    automatic = true;
    dates = "weekly"; # Run weekly
    options = "--delete-older-than 7d"; # Keep generations from the last 30 days
  };

  nix = {
    optimise.automatic = true; # Periodically optimize the store
    optimise.dates = [ "12:00" ]; # Run at 3:45 AM (optional)
    settings.auto-optimise-store = true; # Optimize after builds
  };
}

