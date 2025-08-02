local M = {}

-- Форматирует весь буфер
function M.format_sql()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local content = table.concat(lines, "\n")
  local formatted = vim.fn.system({ "sql-formatter", "-l", "postgresql" }, content)

  if vim.v.shell_error ~= 0 then
    vim.notify("sql-formatter error:\n" .. formatted, vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(formatted, "\n"))
end

-- Форматирует только выделенный текст (visual mode)
function M.format_sql_visual()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2] - 1
  local end_line = end_pos[2]

  local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, false)
  local content = table.concat(lines, "\n")
  local formatted = vim.fn.system({ "sql-formatter", "-l", "postgresql" }, content)

  if vim.v.shell_error ~= 0 then
    vim.notify("sql-formatter error:\n" .. formatted, vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_buf_set_lines(0, start_line, end_line, false, vim.split(formatted, "\n"))
end

return M
