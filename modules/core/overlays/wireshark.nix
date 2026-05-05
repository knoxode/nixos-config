# overlays/wireshark-hash-fix.nix
final: prev: {
  wireshark = prev.wireshark.overrideAttrs (old: {
    src = prev.fetchFromGitLab {
      owner = "wireshark";
      repo = "wireshark";
      tag = "v${old.version}";
      hash = "sha256-Zvrwxjp4LK2J3QnxmPxKKrU01YHQvPyp54UWzeGNCjA=";
    };
  });
}
