vim.g.mapleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- a nice helper grabbed from @malor
function setup_env ()
  local runtime_py3 = vim.fn.stdpath("cache") .. "/runtime/py3"
  local runtime_py3_bin = runtime_py3 .. "/bin/python3"

  if vim.fn.isdirectory(runtime_py3) == 0 then
     local bootstrap = vim.fn.confirm("Bootstrap python3 provider?", "&Yes\n&No", 0, "Question")
     if bootstrap == 1 then
        vim.cmd(string.format("!python3 -m venv '%s'", runtime_py3))
        vim.cmd(string.format("!%s -m pip install pynvim", runtime_py3_bin))
        vim.cmd(string.format("!%s -m pip install pyright", runtime_py3_bin))
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
setup_env()


require("lazy").setup({
    spec = "lazySetup",
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })

require("options")
require("mappings")

