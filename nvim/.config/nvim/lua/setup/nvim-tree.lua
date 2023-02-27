require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
        number = false,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    renderer = {
        group_empty = true,
        indent_markers = {
            enable = true,
        }
    },
    filters = {
        dotfiles = true,
        custom = { "node_modules", ".cache" }
    },
})