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

-- ===== Отступы в normal/visual mode =====
-- В normal mode: >> и << уже работают по умолчанию, оставляем.
-- В visual mode: > и < тоже работают, так что доп. бинды не нужны.

-- Движение строк и выделений вверх/вниз (macOS HHKB)
-- Normal mode
vim.keymap.set("n", "∆", ":m .+1<CR>==", { silent = true, desc = "Move line down" }) -- Alt+j
vim.keymap.set("n", "˚", ":m .-2<CR>==", { silent = true, desc = "Move line up" })   -- Alt+k

-- Visual mode
vim.keymap.set("v", "∆", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "˚", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- ===== Удаление слова под курсором =====
-- diw — удалить слово без пробела
vim.keymap.set("n", "<leader>dw", "diw", { noremap = true, silent = true, desc = "Delete inner word" })
-- daw — удалить слово с пробелом
vim.keymap.set("n", "<leader>dW", "daw", { noremap = true, silent = true, desc = "Delete word with space" })
-- ciw — заменить слово
vim.keymap.set("n", "<leader>cw", "ciw", { noremap = true, silent = true, desc = "Change inner word" })
