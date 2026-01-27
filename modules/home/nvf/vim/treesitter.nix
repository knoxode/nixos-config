{pkgs, ...}: {
  programs.nvf = {
    settings.vim.treesitter = {
      enable = true;
      context.enable = true;
      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        r
        markdown
        rnoweb
        yaml
        toml
      ];
    };
  };
}
