{pkgs, ...}: let
  r_nvim_pkg = pkgs.vimUtils.buildVimPlugin {
    name = "R-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "R-nvim";
      repo = "R.nvim";
      rev = "v0.99.2";
      hash = "sha256-Zg6anafFejoAucy5OxPL5fKm9mRrGoBDNl8luVd9E4w=";
    };
    doCheck = false;
  };
in {
  programs.nvf.settings.vim = {
    extraPlugins = {
      R-nvim = {
        package = r_nvim_pkg;
        setup = ''
          require("r").setup({
            auto_quit = true,

            auto_start = "always",
            objbr_opendf = false,
            objbr_auto_start = true,
            min_editor_width = 999,
            rconsole_height = 15,
            compl_data = {
              max_time = 200,
            },
            R_args = { "--quiet", "--no-save" },
            r_ls = {
              completion = true,
              hover = true,
              signature = true,
            },
          })
        '';
      };
    };
    extraPackages = with pkgs; [];
  };
}
