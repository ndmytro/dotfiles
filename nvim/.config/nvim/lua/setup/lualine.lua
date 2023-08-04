local function getWords()
    if vim.bo.filetype == "md" or vim.bo.filetype == "txt" or vim.bo.filetype == "markdown" then
      if vim.fn.wordcount().visual_words == 1 then
        return tostring(vim.fn.wordcount().visual_words) .. " word"
      elseif not (vim.fn.wordcount().visual_words == nil) then
        return tostring(vim.fn.wordcount().visual_words) .. " words"
      else
        return tostring(vim.fn.wordcount().words) .. " words"
      end
    else
      return ""
    end
  end
  
  function searchResult(quick)
    if vim.v.hlsearch == 0 then
      return ""
    end
    local last_search = vim.fn.getreg("/")
    if not last_search or last_search == "" then
      return ""
    end
    local searchcount = vim.fn.searchcount({ maxcount = 0 })
    return vim.pesc(last_search) .. " (" .. searchcount.current .. "/" .. searchcount.total .. ")"
  end
  
  local function place()
    local colPre = "C:"
    local col = "%c"
    local linePre = " L:"
    local line = "%l/%L"
    return string.format("%s%s%s%s", colPre, col, linePre, line)
  end
  
  --- @param trunc_width number trunctates component when screen width is less then trunc_width
  --- @param trunc_len number truncates component to trunc_len number of chars
  --- @param hide_width number hides component when window width is smaller then hide_width
  --- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
  --- return function that can format the component accordingly
  local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
    return function(str)
      local win_width = vim.fn.winwidth(0)
      if hide_width and win_width < hide_width then
        return ""
      elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
        return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
      end
      return str
    end
  end
  
  local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
      return {
        added = gitsigns.added,
        modified = gitsigns.changed,
        removed = gitsigns.removed,
      }
    end
  end
  
  local function window()
    return vim.api.nvim_win_get_number(0)
  end
  -- get colors from Nightfox to use in the words count
  -- local nfColors = require("nightfox.colors").init("nordfox")
  
  -- print(vim.inspect(nfColors))
  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = { " ", " " },
      -- section_separators = { left = "", right = "" },
      section_separators = { left = "", right = ""},
      disabled_filetypes = {},
    },
    sections = {
      lualine_a = {
        { "mode", fmt = trunc(80, 1, nil, true) },
      },
      lualine_b = {
        { "branch", icon = "" },
        {
          "diff",
          source = diff_source,
          color_added = "#a7c080",
          color_modified = "#ffdf1b",
          color_removed = "#ff6666",
        },
      },
      lualine_c = {
        { "diagnostics", sources = { "nvim_diagnostic" } },
        function()
          return "%="
        end,
        {
          "filename",
          path = 0,
          shorting_target = 40,
          symbols = {
            modified = "[Modified]", -- Text to show when the file is modified.
            readonly = "", -- Text to show when the file is non-modifiable or readonly.
            unnamed = "[No Name]", -- Text to show for unnamed buffers.
            newfile = "[New]", -- Text to show for new created file before first writting
          },
        },
        {
          getWords,
          color = { fg = "#333333", bg = "#eeeeee" },
          separator = { left = "", right = "" },
        },
        {
          searchResult,
        },
      },
      lualine_x = { 
          "filetype",
          {
              "fileformat"
              -- icons_enabled = false,
          },
          {
              "encoding",
              cond = function()
                  -- UTF-8 is the de-facto standard encoding and is what
                  -- most users expect by default. There's no need to
                  -- show encoding unless it's something else.
                  local fenc = vim.opt.fenc:get()
                  return string.len(fenc) > 0 and string.lower(fenc) ~= "utf-8"
              end,
          },
      },
      -- lualine_x = { { "filetype", icon_only = true } },
      lualine_y = { { require("auto-session.lib").current_session_name } },
      lualine_z = {
        { place, padding = { left = 1, right = 1 } },
      },
    },
    inactive_sections = {
      lualine_a = { window },
      lualine_b = {
        {
          "diff",
          source = diff_source,
          color_added = "#a7c080",
          color_modified = "#ffdf1b",
          color_removed = "#ff6666",
        },
      },
      lualine_c = {
        function()
          return "%="
        end,
        {
          "filename",
          path = 1,
          shorting_target = 40,
          symbols = {
            modified = "[Modified]", -- Text to show when the file is modified.
            readonly = "[Readonly]", -- Text to show when the file is non-modifiable or readonly.
            unnamed = "[No Name]", -- Text to show for unnamed buffers.
            newfile = "[New]", -- Text to show for new created file before first writting
          },
        },
      },
      lualine_x = {
        { place, padding = { left = 1, right = 1 } },
      },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = {
      "quickfix",
    },
  })
