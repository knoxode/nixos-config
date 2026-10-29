{...}: {
  imports = [
    ./main.nix
    # ./avante: removed — the native library build alone pulled in rustc
    # (~1 GiB) for the in-nvim OpenRouter assistant. opencode covers this.
    # ./codecompanion/main.nix
    # ./codecompanion/mcps/jina.nix
    # ./codecompanion/mcps/nixos.nix
  ];
}
