local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    execute 'packadd packer.nvim'
end
vim.cmd('packadd packer.nvim')
local packer = require'packer'
local util = require'packer.util'
packer.init({
  package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})


-- In order to use Python plugins, one need 'pynvim' package to be installed.
-- So let's create a Python venv with 'pynvim', and use its interpreter to run
-- Python plugins in order to avoid polluting system namespace.
-- grabbed this snippet from github.com/malor/dotfiles
local py_env_bootstrap = function()
  local runtime_py3 = vim.fn.stdpath("cache") .. "/runtime/py3"
  local runtime_py3_bin = runtime_py3 .. "/bin/python3"

  if vim.fn.isdirectory(runtime_py3) == 0 then
    local bootstrap = vim.fn.confirm("Bootstrap python3 provider?", "&Yes\n&No", 0, "Question")
    if bootstrap == 1 then
       vim.cmd(string.format("!python3 -m venv '%s'", runtime_py3))
       vim.cmd(string.format("!%s -m pip install pynvim", runtime_py3_bin))
    elseif bootstrap == 2 then
       -- Create an empty directory in order to stop asking a user about
       -- boostrapping python3 provider on start.
       vim.fn.mkdir(runtime_py3, "p")
    end
  end

  if vim.fn.filereadable(runtime_py3_bin) == 1 then
    vim.g.python3_host_prog = runtime_py3_bin
  end
end

py_env_bootstrap()


vim.o.termguicolors = false
vim.o.syntax = 'on'
vim.o.errorbells = true
vim.o.smartcase = true
vim.o.showmode = true
vim.bo.swapfile = false
vim.o.backup = false
vim.o.undodir = vim.fn.stdpath('config') .. '/undo'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.completeopt = 'menuone,noinsert,noselect'
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'
vim.wo.wrap = false

local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(
    mode,
    key,
    result,
    {noremap = true, silent = true}
  )
end

vim.g.mapleader = ' '
key_mapper('', '<up>', '<nop>')
key_mapper('', '<down>', '<nop>')
key_mapper('', '<left>', '<nop>')
key_mapper('', '<right>', '<nop>')
key_mapper('i', 'jk', '<ESC>')
key_mapper('i', 'JK', '<ESC>')
key_mapper('i', 'jK', '<ESC>')
key_mapper('v', 'jk', '<ESC>')
key_mapper('v', 'JK', '<ESC>')
key_mapper('v', 'jK', '<ESC>')
key_mapper('n', 'gd', ':lua vim.lsp.buf.definition()<CR>')
key_mapper('n', 'gD', ':lua vim.lsp.buf.declaration()<CR>')
key_mapper('n', 'gi', ':lua vim.lsp.buf.implementation()<CR>')
key_mapper('n', 'gw', ':lua vim.lsp.buf.document_symbol()<CR>')
key_mapper('n', 'gW', ':lua vim.lsp.buf.workspace_symbol()<CR>')
key_mapper('n', 'gr', ':lua vim.lsp.buf.references()<CR>')
key_mapper('n', 'gt', ':lua vim.lsp.buf.type_definition()<CR>')
key_mapper('n', 'K', ':lua vim.lsp.buf.hover()<CR>')
key_mapper('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<CR>')
key_mapper('n', '<leader>af', ':lua vim.lsp.buf.code_action()<CR>')
key_mapper('n', '<leader>rn', ':lua vim.lsp.buf.rename()<CR>')
key_mapper('n', '<C-p>', ':lua require"telescope.builtin".find_files()<CR>')
key_mapper('n', '<leader>fs', ':lua require"telescope.builtin".live_grep()<CR>')
key_mapper('n', '<leader>fh', ':lua require"telescope.builtin".help_tags()<CR>')
key_mapper('n', '<leader>fb', ':lua require"telescope.builtin".buffers()<CR>')

--- startup and add configure plugins
packer.startup(function()
  local use = use
  use 'nvim-treesitter/nvim-treesitter'
  use 'sheerun/vim-polyglot'
  use 'tjdevries/colorbuddy.nvim'
  use 'bkegley/gloombuddy'
  use 'neovim/nvim-lspconfig'
  use 'anott03/nvim-lspinstall'
  -- completion plugins:
  --use 'nvim-lua/completion-nvim'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  -- sneaking some formatting in here too
  use {'prettier/vim-prettier', run = 'yarn install' }
  -- fuzzy finding
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/telescope.nvim'
  use 'jremmen/vim-ripgrep'
  end
)

-- vim.g.colors_name = 'gloombuddy'
local colorbuddy = require'colorbuddy'
colorbuddy.colorscheme('gloombuddy')

local configs = require'nvim-treesitter.configs'
configs.setup {
  ensure_installed = { "c", "python", "yaml", "lua" },
  highlight = {
    enable = true,
  }
}

vim.lsp.set_log_level("debug")
local lspconfig = require'lspconfig'
--local completion = require'completion'

local function custom_on_attach(client)
  print('Attaching to ' .. client.name)
  -- completion.on_attach(client)
end

local default_config = {
  on_attach = custom_on_attach,
}
-- setup language servers here
lspconfig.tsserver.setup(default_config)
lspconfig.pyright.setup(default_config)
lspconfig.clangd.setup(default_config)
lspconfig.bashls.setup(default_config)
lspconfig.yamlls.setup(default_config)


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)

