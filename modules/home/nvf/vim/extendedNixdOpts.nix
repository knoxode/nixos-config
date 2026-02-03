{host, ...}: {
  programs.nvf.settings.vim.lsp.servers.nixd.settings.nixd = {
    nixpkgs.expr = ''
      let
        flake = builtins.getFlake "/home/shaiikura/alexos";
      in
        import flake.inputs.nixpkgs {
          system = builtins.currentSystem;
        }
    '';

    options = {
      nixos.expr = ''
        (builtins.getFlake "/home/shaiikura/alexos")
          .nixosConfigurations.${host}.options
      '';

      home-manager.expr = ''
        (builtins.getFlake "/home/shaiikura/alexos")
          .nixosConfigurations.${host}.options
          .home-manager.users.type.getSubOptions []
      '';
    };
  };
}
