-- SQL: выполнить выделенный запрос
vim.keymap.set("v", "<leader>r",
  [[:<C-u>lua require("config.sql_exec").exec_sql()<CR>]],
  { noremap = true, silent = true, desc = "Run selected SQL" }
)

-- SQL: сохранить результат в CSV и в буфер обмена
vim.keymap.set("v", "<leader>c",
  [[:<C-u>lua require("config.sql_exec").exec_sql_to_csv()<CR>]],
  { noremap = true, silent = true, desc = "Run SQL and copy result as CSV" }
)

-- Подгрузка метаданных
vim.api.nvim_create_user_command("MetadataLoad", function()
  require("utils.metadata").load_metadata_cache()
end, {})

-- Отключение конфликтного Ctrl-Space
vim.keymap.set({ "n", "i" }, "<C-Space>", "<Nop>", { silent = true })

-- Expand * до списка колонок
vim.keymap.set("n", "<leader>e",
  require("utils.expand_star").expand_star,
  { desc = "Expand * to columns" }
)
vim.keymap.set("v", "<leader>e",
  [[:<C-u>lua require("utils.expand_star").expand_star()<CR>]],
  { noremap = true, silent = true, desc = "Expand selection to columns" }
)

-- Форматирование SQL
vim.keymap.set("n", "<leader>f",
  require("utils.sql_formatter").format_sql,
  { desc = "Format entire SQL" }
)
vim.keymap.set("v", "<leader>f",
  [[:<C-u>lua require("utils.sql_formatter").format_sql_visual()<CR>]],
  { noremap = true, silent = true, desc = "Format selected SQL" }
)

-- Сброс подсветки поиска по <Esc>
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR><Esc>", { silent = true })
