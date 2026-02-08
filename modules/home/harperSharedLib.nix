{
  pkgs,
  lib,
  ...
}: let
  commonWords = [
    "Hello"
    "A1"
    "AP2"
    "Agroinfiltration"
    "Alpha2"
    "Arabidopsis"
    "AtSEOR"
    "AttL1"
    "AttLx"
    "B2"
    "B3"
    "B4"
    "B5"
    "B6"
    "BsaI"
    "C."
    "C1"
    "CHH"
    "CMVII"
    "CMVIIs"
    "CTag"
    "CaMV"
    "Cascuta"
    "Cuscuta"
    "DB3"
    "DBD"
    "DDC"
    "DH5"
    "DMRs"
    "DelCMVII"
    "E."
    "ERF96"
    "Electrocompetent"
    "Eppendorf"
    "FullLength"
    "GB256"
    "GB259"
    "GB50"
    "GCGCCGTCTCGCTCnNNNNNNNNNNNNNNNNNNNNN"
    "GFP"
    "GGGGS"
    "GXL"
    "GoldenBraid"
    "GoldenGate"
    "HRPE"
    "Haustorium"
    "Interspecies"
    "LR"
    "Labelling"
    "LexA"
    "Ligase"
    "Luc"
    "Luciferase"
    "Lv0"
    "MACH1"
    "MgCl2"
    "NEB"
    "NLR"
    "NLS"
    "OD600"
    "Omega1"
    "PCA"
    "PCR"
    "PafA"
    "PrimeSTAR"
    "PupE"
    "R2"
    "R212"
    "R21218AA"
    "RAP2"
    "RAP212"
    "RLuc"
    "RNAs"
    "RedSeed"
    "Resuspend"
    "Saima"
    "Shahid"
    "Spectinomycin"
    "T4"
    "TE"
    "TNos"
    "TOP10"
    "Thermo"
    "Transactivation"
    "UTR"
    "Vec"
    "XVE"
    "Xgal"
    "Z3EV"
    "Z3EVprx6"
    "Zif628"
    "Zif628DBD"
    "acetosyrigone"
    "agorinfiltration"
    "agro"
    "agrobacterium"
    "aliquot"
    "alpha1"
    "clonase"
    "coli"
    "csaw"
    "dNTP"
    "dirtyTalk"
    "distilled"
    "docx"
    "epigenomic"
    "hausteria"
    "hypomethylated"
    "lcl"
    "litre"
    "mNG"
    "mNeonG"
    "mNeonGreen"
    "mRNAs"
    "medWait"
    "methylated"
    "methylation"
    "miRNAs"
    "microlitre"
    "micropore"
    "ness"
    "ng"
    "noctalia"
    "novo"
    "nt"
    "oligo"
    "pDEST"
    "pGreen"
    "pUPD2"
    "plasmid"
    "plasmids"
    "refMaterials"
    "serialCloner"
    "silico"
    "smallRNA"
    "smallRNAs"
    "supernatant"
    "tERFVII"
    "ter"
    "thermocycler"
    "transcriptome"
    "ul"
    "upregulated"
    "vitro"
    "x35"
    "x35S"
    "xFLAG"
    "xStrepII"
    "Goodbye"
  ];
  commonWordsFile =
    pkgs.writeText "harper-common-words.txt"
    (builtins.concatStringsSep "\n" commonWords);
  sharedHarpDictGen = pkgs.writeShellScript "harper-shared-dict-gen" ''
    #! ${pkgs.runtimeShell}
    set -euo pipefail

    TARGET="$1"
    WORDLIST="${commonWordsFile}"

    mkdir -p "$(dirname "$TARGET")"

    # Ensure target exists
    if [ ! -f "$TARGET" ]; then
      touch "$TARGET"
    fi

    touch temp.txt

    tmp=temp.txt

    # 1. Write common words first
    cat "$WORDLIST" > "$tmp"

    # 2. Append existing words that are NOT in commonWords
    #    - skip empty lines
    #    - exact match only
    while IFS= read -r line; do
      [ -z "$line" ] && continue

      if ! grep -Fxq "$line" "$WORDLIST"; then
        echo "$line"
      fi
    done < "$TARGET" >> "$tmp"

    # 3. Deduplicate while preserving order
    ${pkgs.gawk}/bin/awk '!seen[$0]++' "$tmp" > "$tmp.final"

    # 4. Replace atomically
    mv "$tmp.final" "$TARGET"
    rm -f "$tmp"
  '';
in {
  home.activation.mkHarperSharedUserDict = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${sharedHarpDictGen} "$HOME/.config/harper-ls/dictionary.txt"
  '';
}
