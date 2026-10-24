{pkgs, ...}: {
  services.ollama = {
    enable = true;

    # NVIDIA GPU acceleration
    package = pkgs.ollama-cuda;

    # Automatically download required models
    loadModels = [
      "qwen2.5-coder:7b"
    ];

    # Keep additional experimental models installed
    syncModels = false;

    # Listen on all interfaces; firewall limits access
    host = "0.0.0.0";
    port = 11434;

    # Don't open the port globally
    openFirewall = false;

    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "10m";
      OLLAMA_NUM_PARALLEL = "1";
    };
  };

  # Allow Ollama access only through WireGuard
  networking.firewall.interfaces.wg0.allowedTCPPorts = [
    11434
  ];
}
