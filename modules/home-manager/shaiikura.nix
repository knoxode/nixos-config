{ inputs, pkgs, ... }:

{
  home.username = "shaiikura";
  home.homeDirectory = "/home/shaiikura";
  imports = [
    inputs.nvchad4nix.homeManagerModule
    inputs.spicetify-nix.homeManagerModules.default
    # ./ags.nix
    ./bash.nix
    ./firefox.nix
    ./hyprland.nix
    ./fastfetch.nix
    ./kitty.nix
    ./waypaper.nix
    ./grim.nix
    ./wlogout.nix
    ./spicetify.nix
    ./fish.nix
    ./rofi.nix
    ./onedrive.nix
  ];

  home.file.".config/rstudio/rstudio-prefs.json".source = ./../../preferences/rstudio-prefs.json;

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  home.packages = with pkgs; [
   htop 
   file    
   wl-clipboard
   # rstudio
   kitty
   mendeley
  ];

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
    ];
    chadrcConfig = builtins.readFile ./../../preferences/nvim/chadrc.lua;
    extraConfig = builtins.readFile ./../../preferences/nvim/extraConfig.lua;
  };

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'christoomey/vim-tmux-navigator'
    '';
  };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
