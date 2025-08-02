vim.keymap.set("v", "<leader>r", [[:<C-u>lua require("config.sql_exec").exec_sql()<CR>]], { noremap = true, silent = true })
vim.api.nvim_create_user_command("MetadataLoad", function()
  require("utils.metadata").load_metadata_cache()
end, {})
vim.keymap.set({ "n", "i" }, "<C-Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<leader>e", require("utils.expand_star").expand_star, { desc = "Expand * to columns" })
vim.keymap.set("v", "<leader>e", require("utils.expand_star").expand_star, { desc = "Expand selection to columns" })

-- В normal mode форматирует весь буфер
vim.keymap.set("n", "<leader>f", require("utils.sql_formatter").format_sql, { desc = "Format entire SQL" })
-- В visual mode форматирует выделение
vim.keymap.set("v", "<leader>f", require("utils.sql_formatter").format_sql_visual, { desc = "Format selected SQL" })
-- при нажатии <Esc> в normal-режиме будет автоматически сбрасываться подсветка поиска.
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR><Esc>", { silent = true })
