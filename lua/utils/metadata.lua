local M = {}

local json = vim.fn.json_encode and vim.fn.json_decode
local data_path = vim.fn.stdpath("data")
local tmpfile = data_path .. "/metadata_result.csv"
local jsonfile = data_path .. "/metadata_cache.json"
local logfile = data_path .. "/metadata_cache.log"

M.metadata_cache = {}

-- Загружаем кэш из JSON при запуске
local function load_cache_from_json()
  local f = io.open(jsonfile, "r")
  if f then
    local contents = f:read("*a")
    f:close()
    local ok, parsed = pcall(vim.fn.json_decode, contents)
    if ok and parsed then
      M.metadata_cache = parsed
    end
  end
end

-- Сохраняем кэш в JSON
local function save_cache_to_json(cache)
  local f = io.open(jsonfile, "w")
  if f then
    f:write(vim.fn.json_encode(cache))
    f:close()
  end
end

-- Основной метод для загрузки кэша через psql
M.load_metadata_cache = function()
  -- SQL-запрос
  local query = [[
\pset format csv
\o ]] .. tmpfile .. [[

SELECT table_schema, table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema NOT IN ('information_schema', 'pg_catalog');
]]

  -- Сохраняем SQL во временный файл
  local sqlfile = data_path .. "/load_metadata.sql"
  local f = io.open(sqlfile, "w")
  f:write(query)
  f:close()

  -- Выполняем через psql
  local cmd = "psql -f " .. sqlfile
  os.execute(cmd)

  -- Читаем результат
  local cache = {}
  for line in io.lines(tmpfile) do
    local schema, table_name, column, datatype = line:match("^([^,]+),([^,]+),([^,]+),([^,]+)$")
    if schema and table_name and column then
      local fq_table = schema .. "." .. table_name
      cache[fq_table] = cache[fq_table] or {}
      table.insert(cache[fq_table], { name = column, type = datatype })
    end
  end

  -- Сохраняем в переменную, JSON и лог
  M.metadata_cache = cache
  save_cache_to_json(cache)

  local log = io.open(logfile, "w")
  log:write(vim.inspect(cache))
  log:close()

  print("[metadata] Loaded " .. tostring(vim.tbl_count(cache)) .. " tables into cache.")
end

-- При загрузке этого модуля сразу читаем JSON-кэш
load_cache_from_json()

return M
