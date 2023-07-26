-- returns the require for use in `config` parameter of lazy's use
-- expects the name of the config file
function get_setup(name)
  return function()
    require("setup." .. name)
  end
end

return {
  -- { "sainnhe/everforest", config = get_setup("everforest") },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, config=get_setup("catppuccin") },
--  { "folke/tokyonight.nvim", config = get_setup("tokyonight") },
  { "lukas-reineke/indent-blankline.nvim" },
--  { "nvim-tree/nvim-web-devicons", config = get_setup("nvim-web-devicons") },
--  { "nvim-tree/nvim-tree.lua", config = get_setup("nvim-tree") },
  { "numToStr/Comment.nvim", config = get_setup("comment") },
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope.nvim", cmd = "Telescope", config = get_setup("telescope") },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "neovim/nvim-lspconfig", config = get_setup("lsp") },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/cmp-vsnip" },
      { "hrsh7th/vim-vsnip-integ" },
      { "hrsh7th/cmp-calc" },
      { "rafamadriz/friendly-snippets" },
    },
    config = get_setup("cmp"),
    event = "InsertEnter",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = get_setup("treesitter"),
    build = ":TSUpdate",
    event = "BufReadPost",
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  {
    "folke/which-key.nvim",
    config = get_setup("which-key"),
    event = "VeryLazy",
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = get_setup("gitsigns"),
  },
  -- {
  --   "gen740/SmoothCursor.nvim",
  --   config = get_setup("smoothcursor"),
  -- },
  {
    "nvim-lualine/lualine.nvim",
    config = get_setup("lualine"),
    event = "VeryLazy",
  },
  { "kdheepak/lazygit.nvim" },
  { "rmagatti/auto-session", config = get_setup("autosession") },
  { "f-person/git-blame.nvim" },
  { "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, 
    config=get_setup("trouble") 
  }
}
