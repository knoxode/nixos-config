{pkgs, ...}: {
  programs.vscode = {
    enable = false;
    profiles = {
      default = {
        extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          github.codespaces
          jnoortheen.nix-ide
          ms-vscode-remote.vscode-remote-extensionpack
          vscodevim.vim
          yzhang.markdown-all-in-one
          nextflow.nextflow
          tomoki1207.pdf
        ];
      };
    };
  };
}
