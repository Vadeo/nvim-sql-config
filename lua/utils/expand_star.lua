local M = {}

local function get_table_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local table_name = line:match("from%s+([%w_%.]+)") or line:match("join%s+([%w_%.]+)")
  return table_name
end

M.expand_star = function()
  local table_name = get_table_under_cursor()
  if not table_name then
    print("❌ Таблица не найдена рядом с курсором.")
    return
  end

  local cache = require("utils.metadata").metadata_cache
  local columns = cache[table_name]

  if not columns then
    print("❌ Таблица " .. table_name .. " не найдена в metadata_cache.")
    return
  end

  local colnames = {}
  for _, col in ipairs(columns) do
    table.insert(colnames, col.name)
  end

  -- Заменяем выделенный текст или `*` под курсором
  local mode = vim.fn.mode()
  local replacement = table.concat(colnames, ", ")

  if mode == "v" or mode == "V" then
    -- Заменим визуальное выделение
    vim.api.nvim_feedkeys('"_c' .. replacement, "n", true)
  else
    -- Найдём * под курсором и заменим
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local new_line = line:gsub("%*", replacement, 1)
    vim.api.nvim_set_current_line(new_line)
  end
end

return M
