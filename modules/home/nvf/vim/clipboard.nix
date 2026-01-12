{inputs, ...}: {
  programs.nvf = {
    settings.vim = {
      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers = {
          wl-copy.enable = true;
          xsel.enable = true;
        };
      };
    };
  };
}
