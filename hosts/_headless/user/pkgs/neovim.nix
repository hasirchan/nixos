{ config, lib, pkgs, osConfig, ... } :
{
  programs.neovim = {
    enable = true;
    package = lib.mkIf osConfig.programs.neovim.enable osConfig.programs.neovim.package; 
    extraLuaConfig = ''
      vim.cmd [[
        highlight Normal guibg=none
        highlight NonText guibg=none
        highlight Normal ctermbg=none
        highlight NonText ctermbg=none
       ]]
      
      vim.api.nvim_set_keymap('i', 'jj', '<Esc>', { noremap = true, silent = true })
  
      vim.opt.clipboard = "unnamedplus"
      vim.opt.number = true
      vim.opt.expandtab = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.softtabstop = 2
      vim.opt.smartindent = true
      vim.opt.autoindent = true
      vim.opt.smarttab = true
    '';
    plugins = with pkgs.vimPlugins; [];
  };
}
