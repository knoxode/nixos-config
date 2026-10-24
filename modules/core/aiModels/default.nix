{host, ...}: {
  imports =
    if host == "node"
    then [./ollama.nix]
    else [];
}
