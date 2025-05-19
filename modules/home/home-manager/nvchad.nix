{
  pkgs,
  inputs,
  ...
}:
{
  imports = [inputs.nvchad4nix.homeManagerModule];
  programs.nvchad = {
    enable = true;
    backup = false;
    extraPlugins =''
    return {
      {"nvimtools/none-ls.nvim", lazy=true, dependencies = { "nvimtools/none-ls-extras.nvim", }},
      {"stsewd/isort.nvim", lazy=true},
      {"christoomey/vim-tmux-navigator", lazy=false}
    } 
    '';
    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      nil
      nixpkgs-fmt
      pyright
      isort
      black
      nodePackages_latest.prettier
      nodePackages.eslint_d
      clang-tools
      dockerfile-language-server-nodejs
    ];
    chadrcConfig = builtins.readFile ../../../../preferences/nvim/chadrc.lua;
    extraConfig = builtins.readFile ../../../../preferences/nvim/extraConfig.lua;
  };
}
