{pkgs, ...}: {
  programs.vscode = {
    enable = false;
    profiles = {
      default = {
        extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
          # catppuccin.catppuccin-vsc
          # catppuccin.catppuccin-vsc-icons
          github.codespaces
          jnoortheen.nix-ide
          ms-vscode-remote.vscode-remote-extensionpack
          vscodevim.vim
          yzhang.markdown-all-in-one
          tomoki1207.pdf
        ];
      };
    };
  };
}
