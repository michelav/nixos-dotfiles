{ inputs, config, pkgs, ... }:
{
  home.sessionVariables.EDITOR = "nvim";

  home.packages = with pkgs; [
    sumneko-lua-language-server
    rnix-lsp
    nur.repos.ouzu.catppuccin.gtk
    nodejs
    tree-sitter
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.pyright
  ];

  programs.neovim = 
  let
    nvimExtraPlugins = pkgs.callPackage ./extraPlugins.nix { inherit pkgs; };
  in
   {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      lua require('init')
    '';

    plugins = with pkgs; with vimPlugins; [
      vim-nix
      nvim-treesitter
      nvim-lspconfig

      # Basic
      telescope-nvim
      telescope-fzf-native-nvim
      plenary-nvim
      nvim-web-devicons
      which-key-nvim
      indent-blankline-nvim
      gitsigns-nvim
      comment-nvim
      hop-nvim

      # Completions
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-treesitter
      cmp-path
      cmp-buffer
      cmp-vsnip
      luasnip
      cmp_luasnip
      cmp-nvim-lsp-document-symbol
      cmp-cmdline
      friendly-snippets

      # Status
      feline-nvim

      # Themes
      nightfox-nvim
      nvimExtraPlugins.nvim-catppuccin
    ];
  };
  xdg.configFile."nvim/lua".source = ../../../../config/nvim/lua;
}
