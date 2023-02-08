local km = vim.keymap

-- km.set("n", "<leader>e", ":NvimTreeOpen<CR>", { desc = "Open tree file explorer" })


-- Here is a utility function that closes any floating windows when you press escape
local function close_floating()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "win" then
      vim.api.nvim_win_close(win, false)
    end
  end
end

km.set("n", "<Leader>u", ":Lazy update<CR>", { desc = "Lazy Update (Sync)" })

km.set("n", "<Leader>n", "<cmd>enew<CR>", { desc = "New File" })

km.set("n", "<Leader>a", "ggVG<c-$>", { desc = "Select All" })

-- Make visual yanks place the cursor back where started
km.set("v", "y", "ygv<Esc>", { desc = "Yank and reposition cursor" })

km.set("n", "<Delete>", "<cmd>:w<CR>", { desc = "Save file" })

-- km.set("n", "<leader>xu", ":UndotreeToggle<cr>", { desc = "Undo Tree" })
-- More molecular undo of text
km.set("i", ".", ".<c-g>u")
km.set("i", "!", "!<c-g>u")
km.set("i", "?", "?<c-g>u")
km.set("i", ";", ";<c-g>u")
km.set("i", ":", ":<c-g>u")

km.set("n", "<esc>", function()
  close_floating()
  vim.cmd(":noh")
end, { silent = true, desc = "Remove Search Highlighting, Dismiss Popups" })

km.set("n", "<leader>l", ":LazyGit<cr>", { silent = true, desc = "Lazygit" })

-- Easy add date/time
function date()
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(0, pos) .. "# " .. os.date("%d.%m.%y") .. line:sub(pos + 1)
  vim.api.nvim_set_current_line(nline)
  vim.api.nvim_feedkeys("o", "n", true)
end

km.set("n", "<Leader>d", "<cmd>lua date()<cr>", { desc = "Insert Date" })

km.set("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { expr = true, desc = "if j > 5 add to jumplist" })

km.set("n", "<leader>p", function()
  require("telescope.builtin").find_files()
end, { desc = "Files Find" })

km.set("n", "<leader>r", function()
  require("telescope.builtin").registers()
end, { desc = "Browse Registers" })

km.set("n", "<leader>m", function()
  require("telescope.builtin").marks()
end, { desc = "Browse Marks" })

km.set("n", "<leader>f", function()
  require("telescope.builtin").live_grep()
end, { desc = "Find string" })

km.set("n", "<leader>b", function()
  require("telescope.builtin").buffers()
end, { desc = "Browse Buffers" })

km.set("n", "<leader>j", function()
  require("telescope.builtin").help_tags()
end, { desc = "Browse Help Tags" })

km.set("n", "<leader>gc", function()
  require("telescope.builtin").git_bcommits()
end, { desc = "Browse File Commits" })

km.set("n", "<leader>e", function()
  require("telescope").extensions.file_browser.file_browser()
end, { desc = "Files Explore" })

km.set("n", "<leader>E", function()
  require("telescope").extensions.file_browser.file_browser({ select_buffer = true, path = '%:p:h' })
end, { desc = "Explore Current File Location" })

km.set("n", "<leader>R", function()
  require("telescope.builtin").resume()
end, { desc = "Resume Telescope Search" })

km.set("n", "<leader>s", function()
  require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
end, { desc = "Spelling Suggestions" })

km.set("n", "<leader>gs", function()
  require("telescope.builtin").git_status()
end, { desc = "Git Status" })

km.set("n", "<leader>ca", function()
  vim.lsp.buf.code_action()
end, { desc = "Code Actions" })

km.set("n", "<leader>ch", function()
  vim.lsp.buf.hover()
end, { desc = "Code Hover" })

km.set("n", "<leader>cs", function()
  require("telescope.builtin").lsp_document_symbols()
end, { desc = "Code Symbols" })

km.set("n", "<leader>cd", function()
  require("telescope.builtin").diagnostics({ bufnr = 0 })
end, { desc = "Code Diagnostics" })

km.set("n", "<leader>cr", function()
  require("telescope.builtin").lsp_references()
end, { desc = "Code References" })

km.set({ "v", "n" }, "<leader>cn", function()
  vim.lsp.buf.rename()
end, { noremap = true, silent = true, desc = "Code Rename" })

km.set("n", "<Leader><Down>", "<C-W><C-J>", { silent = true, desc = "Window Down" })
km.set("n", "<Leader><Up>", "<C-W><C-K>", { silent = true, desc = "Window Up" })
km.set("n", "<Leader><Right>", "<C-W><C-L>", { silent = true, desc = "Window Right" })
km.set("n", "<Leader><Left>", "<C-W><C-H>", { silent = true, desc = "Window Left" })
km.set("n", "<Leader>wr", "<C-W>R", { silent = true, desc = "Window Resize" })
km.set("n", "<Leader>=", "<C-W>=", { silent = true, desc = "Window Equalise" })

-- Easier window switching with leader + Number
-- Creates mappings like this: km.set("n", "<Leader>2", "2<C-W>w", { desc = "Move to Window 2" })
for i = 1, 6 do
  local lhs = "<Leader>" .. i
  local rhs = i .. "<C-W>w"
  km.set("n", lhs, rhs, { desc = "Move to Window " .. i })
end

km.set("i", "<A-BS>", "<C-W>", { desc = "Option+BS deletes whole word" })

km.set("n", "<Leader>xs", ":SearchSession<CR>", { desc = "Search Sessions" })

km.set("n", "<Leader>xn", ":let @+=@%<cr>", { desc = "Copy Buffer name and path" })

km.set("n", "<Leader>xc", ":g/console.lo/d<cr>", { desc = "Remove console.log" })
