{ config, pkgs, ... }:
{
  home.sessionVariables.EDITOR = "nvim";
  programs.neovim = {
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

      # Completions
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-treesitter
      cmp-path
      cmp-buffer
      cmp-vsnip
      cmp-nvim-lsp-document-symbol

      # Status
      feline-nvim

      # Themes
      nightfox-nvim
    ];
  };
  xdg.configFile."nvim/lua".source = ../../config/nvim/lua;
}
