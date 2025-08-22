local cmp = require("cmp")

local source = {}

-- 🔹 Функция для удаления дублей по label
local function deduplicate_items(items)
  local seen = {}
  local unique = {}
  for _, item in ipairs(items) do
    if not seen[item.label] then
      table.insert(unique, item)
      seen[item.label] = true
    end
  end
  return unique
end

function source:is_available()
  return true
end

function source:complete(_, callback)
  local items = {}
  local cache = require("utils.metadata").metadata_cache

  for table_name, columns in pairs(cache) do
    -- сначала добавляем таблицу
    table.insert(items, {
      label = table_name,
      kind = cmp.lsp.CompletionItemKind.Class,
    })

    -- затем её колонки
    for _, col in ipairs(columns) do
      table.insert(items, {
        label = col.name,
        kind = cmp.lsp.CompletionItemKind.Field,
        detail = table_name,
      })
    end
  end

  -- 🔹 применяем deduplication
  local unique_items = deduplicate_items(items)

  callback({ items = unique_items, isIncomplete = false })
end

local M = {}

M.new = function()
  return setmetatable({}, { __index = source })
end

return M
