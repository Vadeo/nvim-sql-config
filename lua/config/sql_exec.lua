local M = {}

-- Надёжный выбор выделенного SQL — целые строки
local function get_visual_selection()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_row = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_row = end_pos[2] - 1
  local end_col = end_pos[3]

  if start_row == end_row then
    local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]
    return string.sub(line, start_col + 1, end_col)
  else
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
    lines[1] = string.sub(lines[1], start_col + 1)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
    return table.concat(lines, "\n")
  end
end

-- Логирование в файл
local function log_query_to_file(query)
  local log_file = vim.fn.stdpath("data") .. "/sql_history.log"
  local f = io.open(log_file, "a")
  if f then
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    f:write(string.format("[%s]\n%s\n\n", timestamp, query))
    f:close()
  else
    vim.notify("⚠️ Failed to open log file", vim.log.levels.ERROR)
  end
end

-- 🔹 Старый способ — запуск через терминал
function M.exec_sql()
  local sql = get_visual_selection()
  if not sql or sql == "" then
    vim.notify("No SQL selected.", vim.log.levels.WARN)
    return
  end

  log_query_to_file(sql)

  local tmpfile = os.tmpname() .. ".sql"
  local f = io.open(tmpfile, "w")
  if not f then
    vim.notify("Failed to open temp file", vim.log.levels.ERROR)
    return
  end
  f:write(sql)
  f:close()

  local cmd = string.format("psql -h snowplow.xtools.tv -p 5439 -U vselin -d dev -f %s", tmpfile)
  vim.cmd("botright split | terminal " .. cmd)
end

-- 🔹 Новый способ — выгрузка в CSV и копирование в буфер обмена
function M.exec_sql_to_csv()
  local sql = get_visual_selection()
  if not sql or sql == "" then
    vim.notify("No SQL selected.", vim.log.levels.WARN)
    return
  end

  log_query_to_file(sql)

  local data_path = vim.fn.stdpath("data")
  local tmp_sql = os.tmpname() .. ".sql"
  local tmp_csv = data_path .. "/last_query.csv"

  -- Сохраняем SQL во временный файл
  local f = io.open(tmp_sql, "w")
  f:write(sql)
  f:close()

  -- PSQL выгружает результат в CSV (с заголовками)
  local cmd = string.format(
    [[psql -h snowplow.xtools.tv -p 5439 -U vselin -d dev --csv -f %s > %s]],
    tmp_sql,
    tmp_csv
  )
  os.execute(cmd)

  -- Читаем CSV
  local result = ""
  local rf = io.open(tmp_csv, "r")
  if rf then
    result = rf:read("*all")
    rf:close()
  end

  if result ~= "" then
    -- Копируем в буфер обмена
    vim.fn.setreg("+", result)
    vim.notify("✅ Query result with headers copied to clipboard and opened in buffer", vim.log.levels.INFO)

    -- Открываем CSV в отдельном сплите
    vim.cmd("botright split | edit " .. tmp_csv)
  else
    vim.notify("⚠️ No result returned", vim.log.levels.WARN)
  end
end
vim.api.nvim_create_user_command("SqlLogOpen", function()
  vim.cmd("edit " .. vim.fn.stdpath("data") .. "/sql_history.log")
end, {})


return M
