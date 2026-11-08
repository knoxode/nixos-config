{
  pkgs,
  lib,
  ...
}: let
  commonWordsFile = ./harper-common-words.txt;

  sharedHarpDictGen = pkgs.writeShellApplication {
    name = "harper-shared-dict-gen";

    runtimeInputs = with pkgs; [
      coreutils
      gawk
      gnugrep
    ];

    runtimeEnv = {
      WORDLIST = "${commonWordsFile}";
    };

    text = builtins.readFile ./harper-shared-dict.sh;
  };
in {
  home.activation.mkHarperSharedUserDict = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${lib.getExe sharedHarpDictGen} "$HOME/.config/harper-ls/dictionary.txt"
  '';
}
