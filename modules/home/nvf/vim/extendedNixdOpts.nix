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

      nvf.expr = ''
        let
          options =
            (builtins.getFlake "/home/shaiikura/alexos")
              .nixosConfigurations.${host}.options
              .home-manager.users.type.getSubOptions [];

          nvf =
            options.programs.nvf.settings.type.getSubOptions [];

          setup =
            nvf.vim.filetree.neo-tree.setupOpts.type.getSubOptions [];
        in {
          programs.nvf.settings.vim.filetree.neo-tree.setupOpts =
            setup;
        }
      '';
    };
  };
}
