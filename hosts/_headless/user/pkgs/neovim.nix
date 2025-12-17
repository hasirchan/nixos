{ config, lib, pkgs, osConfig, ... } :
{
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    fd
    ripgrep
  ];
  programs.neovim = {
    enable = true;
    package = lib.mkIf osConfig.programs.neovim.enable osConfig.programs.neovim.package; 
    extraLuaConfig = let

      terminalSettings = ''
        vim.keymap.set('t', 'jj', [[<C-\><C-n>]], { desc = 'Exit terminal' })

        local term_group = vim.api.nvim_create_augroup("TerminalSettings", { clear = true })
        vim.api.nvim_create_autocmd("TermOpen", {
          group = term_group,
          pattern = "term://*",
          callback = function()
            vim.cmd("startinsert")
          end,
        })
        vim.api.nvim_create_autocmd("BufEnter", {
          group = term_group,
          pattern = "term://*",
          command = "startinsert",
        })
      '';
      general = ''
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
      diagnosis = ''
        vim.diagnostic.config({
          virtual_text = true,
          underline = true,
          signs = true,
          float = {
            border = "rounded",
            source = "always",
          },
        })
      '';

      tabCompletion = ''
        vim.keymap.set('i', '<Tab>', function()
          if vim.fn.pumvisible() == 1 then
            return '<C-n>'
          else
            return '<C-x><C-o>'
          end
        end, { expr = true })

        vim.keymap.set('i', '<CR>', function()
          return vim.fn.pumvisible() ~= 0 and '<C-y>' or '<CR>'
        end, { expr = true })
      '';

      leaderKeyMap = ''
        vim.g.mapleader = " "
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find Files' })
        vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Live Grep' })
        vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'List Buffers' })
        vim.keymap.set('n', '<leader>r', builtin.oldfiles, { desc = 'Recent Files' })

      '';
      lspConfig = ''
        vim.lsp.config('rust_analyzer', {
          cmd = { 'rust-analyzer' },
          root_markers = { 'Cargo.toml', '.git' },
          filetypes = { "rust" },
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = true,
              check = { command = 'clippy' },
            },
          },
        })

        vim.lsp.enable('rust_analyzer')

        vim.lsp.config('nixd', {
          cmd = { "nixd" },
          root_markers = { "flake.nix", ".git" },
          filetypes = { "nix" },
          settings = {
            nixd = {
              formatting = {
                command = { "nixfmt" },
              },
            },
          },
        })

        vim.lsp.enable('nixd')
      '';

    in ''
      ${general}
      ${terminalSettings}
      ${diagnosis}
      ${tabCompletion}
      ${leaderKeyMap}
      ${lspConfig}
    '';
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      plenary-nvim
    ];
  };
}
