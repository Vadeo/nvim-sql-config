local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- 🎨 Цветовая схема (загружается сразу)
--  {
--    "EdenEast/nightfox.nvim",
--    lazy = false, -- грузим сразу
--    priority = 1000, -- загружается раньше других плагинов
--  },
    {
        "sainnhe/everforest",
        lazy = false,
        priority = 1000,
    },
-- Telescope (Поиск по папкам и по содержимому файлов)
  { 
    "nvim-telescope/telescope.nvim", 
    version = "0.1.x",  -- указать нужную версию или latest
    dependencies = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
    config = function()
      require("config.telescope")  -- файл с кастомными настройками
    end,
  },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },

  -- 🔍 Autocompletion engine + deps (загружается сразу, чтобы избежать конфликтов)
  {
    "hrsh7th/nvim-cmp",
    lazy = false,
    priority = 1001,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      require("config.cmp")
    end,
  },

{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- для иконок (опционально)
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true, -- закрывать, если это последний открытый сплит
      filesystem = {
        follow_current_file = { enabled = true }, -- следить за открытым файлом
        hijack_netrw_behavior = "open_default",   -- заменить netrw
      },
    })
  end,
},

  -- 🔀 tmux-навигация между сплитами
  {
    "christoomey/vim-tmux-navigator",
    lazy = true,
    event = "VeryLazy",
  },

  -- 🖊️ Multicursor (Ctrl-n или Visual Block + I/A)
  {
    "mg979/vim-visual-multi",
    branch = "master",
    lazy = true,
    event = "VeryLazy",
  },

})
