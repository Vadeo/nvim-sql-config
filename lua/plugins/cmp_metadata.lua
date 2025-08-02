local cmp = require("cmp")

local source = {}

function source:is_available()
  return true
end

function source:complete(_, callback)
  local items = {}
  local cache = require("utils.metadata").metadata_cache
  for table_name, columns in pairs(cache) do
    table.insert(items, {
      label = table_name,
      kind = cmp.lsp.CompletionItemKind.Class,
    })
    for _, col in ipairs(columns) do
      table.insert(items, {
        label = col.name,
        kind = cmp.lsp.CompletionItemKind.Field,
        detail = table_name,
      })
    end
  end
  callback({ items = items, isIncomplete = false })
end

local M = {}

M.new = function()
  return setmetatable({}, { __index = source })
end

return M
