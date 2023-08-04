-- LSP this is needed for LSP completions in CSS along with the snippets plugin
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

-- Give me rounded borders everywhere
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Different machine VAR for office
local envMachine = os.getenv("MACHINE")
if envMachine == "work" then
  machineCmd =
    "/System/Volumes/Data/usr/local/lib/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server"
else
  machineCmd = "vscode-css-language-server"
end

--Enable (broadcasting) snippet capability for completion
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- LSP Server config
require("lspconfig").cssls.setup({
  capabilities = capabilities,
  cmd = { machineCmd, "--stdio" },
  settings = {
    scss = {
      lint = {
        idSelector = "warning",
        zeroUnits = "warning",
        duplicateProperties = "warning",
      },
      completion = {
        completePropertyWithSemicolon = true,
        triggerPropertyValueCompletion = true,
      },
    },
  },
  on_attach = function(client)
    client.server_capabilities.document_formatting = false
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = "rounded",
          source = "always",
          prefix = " ",
          scope = "cursor",
        }
        vim.diagnostic.open_float(nil, opts)
      end,
    })
  end,
})
require("lspconfig").tsserver.setup({
  capabilities = capabilities,
  on_attach = function(client)
    client.server_capabilities.document_formatting = false
  end,
})

require("lspconfig").html.setup({
  capabilities = capabilities,
  on_attach = function(client)
    client.server_capabilities.document_formatting = false
  end,
})

-- local function get_python_path(workspace)
--   local util = require("lspconfig.util")
--   local path = util.path
--   -- Use activated virtualenv.
--   if vim.env.VIRTUAL_ENV then
--     return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
--   end
--
--   -- Find the name of the pyenv managed environment.
--   for _, pattern in ipairs({ "*", ".*" }) do
--     local match = vim.fn.glob(path.join(workspace, pattern, ".python-version"))
--     if match ~= "" then
--       local env_name = vim.cmd(string.format("!cat %s/.python-version", path.dirname(match)))
--       return "/Users/dmitryn/.pyenv/versions/" .. env_name .. "/bin/python"
--     end
--   end
--   -- Fallback to system Python.
--   return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
-- end
--

local function get_python_path()
    local versions_path = "~/.pyenv/versions/"
    local util = require("lspconfig.util")
    local path = util.path
    if vim.env.VIRTUAL_ENV then
        local python_path = path.join(vim.env.VIRTUAL_ENV, "bin", "python")
        vim.api.nvim_echo({{python_path}}, true, {})
        return python_path
    end
    if vim.fn.filereadable(vim.fn.getcwd() .. ".python-version") == 1 then
        local lines = vim.fn.readfile(vim.fn.getcwd() .. ".python-version")
        local env_name = lines[1]
        vim.api.nvim_echo({{env_name}}, true, {})
        local python_path = path.join(glob(versions_path), env_name, "bin", "python")
        return python_path
    end
    return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

require("lspconfig").pyright.setup({
    capabilities = capabilities,
    -- vim.fn.stdpath("data") .. 
    -- cmd = {"/Users/dmitryn/.local/nvim/runtime/py3/bin/pyright-langserver", "--stdio"},
    -- settings = {
    --     python = {
    --         venvPath = '/Users/dmitryn/.pyenv/versions/',
    --         pythonPath = ''
    --     },
    --     -- analysis = {
    --     --     stubPath = vim.fn.expand "$HOME/typings",
    --     -- },
    -- },
    --
    on_attach = function(client)
         client.server_capabilities.document_formatting = false
           -- Enable completion triggered by <c-x><c-o>
         -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

         -- Mappings.
         -- See `:help vim.lsp.*` for documentation on any of the below functions

         local bufopts = { noremap=true, silent=true, buffer=bufnr }
         vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
             noremap=true, silent=true, buffer=bufnr, desc = 'Go to declaration'
         })
         vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
             noremap=true, silent=true, buffer=bufnr, desc = 'Go to definition'
         })
         vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
         vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
         vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
         vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
         vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
         vim.keymap.set('n', '<space>wl', function()
           print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
         end, bufopts)
         vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
         vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
         vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
         vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
         vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    end,
    -- more abount on_init here: https://github.com/neovim/nvim-lspconfig/issues/500
    on_init = function(client)
        client.config.settings.python.venvPath = '/Users/dmitryn/.pyenv/versions/'
        client.config.settings.python.pythonPath = get_python_path()
    end,
  })

-- LSP Prevents inline buffer annotations
vim.diagnostic.open_float()
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
  signs = true,
  underline = true,
  update_on_insert = false,
})

local signs = {
  Error = "",
  Warn = "󰆽",
  Hint = "",
  Info = "󰙎",
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
end
