{pkgs, ...}: {
  programs.nvf = {
    settings.vim = {
      extraPlugins = with pkgs.vimPlugins; {
      };

      extraPackages = with pkgs; [];
    };
  };
}
