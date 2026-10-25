{host, ...}: let
  inherit (import ../../../hosts/${host}/variables.nix) hostType;
in {
  imports =
    if hostType == "Desktop"
    then [./ollama.nix]
    else [];
}
