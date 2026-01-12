{
  inputs,
  config,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;
    settings.vim = {
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
      lineNumberMode = "number";
      enableLuaLoader = true;
      preventJunkFiles = true;
      options = {
        tabstop = 4;
        shiftwidth = 2;
        wrap = false;
      };

      session = {
        nvim-session-manager.enable = false;
      };
      comments = {
        comment-nvim.enable = true;
      };
    };
  };

  home.activation = {
    dirtytalkUpdate = ''
      # Create the spell directory if it doesn't exist
      mkdir -p "$HOME/.local/share/nvim/site/spell"

      # Try to run DirtytalkUpdate in headless mode with better error handling
      if ! ${config.programs.nvf.finalPackage}/bin/nvim --headless -c "DirtytalkUpdate" -c "qa!" 2>/dev/null; then
        echo "Note: DirtytalkUpdate will run automatically on first Neovim startup"
      fi
    '';
  };
}
