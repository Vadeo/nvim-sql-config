local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
  pickers = {
    find_files = { theme = "dropdown" },
    live_grep = { theme = "dropdown" },
  },
  extensions = {
    fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true },
  },
})

-- Загружай fzf-расширение, если оно установлено
pcall(require("telescope").load_extension, "fzf")

-- Горячие клавиши
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Telescope Find Files" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep,  { desc = "Telescope Live Grep" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers,    { desc = "Telescope Buffers" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags,  { desc = "Telescope Help Tags" })
