{ config, lib, pkgs, inputs, ... } :
{
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  programs.nvchad = {
    enable = true;
    extraConfig = ''
      vim.api.nvim_set_keymap('i', 'jj', '<ESC>', { noremap = true, silent = true })
    '';
  };

}
