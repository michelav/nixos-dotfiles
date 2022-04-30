{ config, pkgs, ... }:
{
  home.sessionVariables.EDITOR = "nvim";
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    coc.enable = true;

  #   plugins = [
  #    {
  #      plugin = nvim-colorizer-lua;
  #      config = ''
  #        packadd! nvim-colorizer.lua
  #        lua require 'colorizer'.setup()
  #       '';
  #    }
  #  ];
  };
}