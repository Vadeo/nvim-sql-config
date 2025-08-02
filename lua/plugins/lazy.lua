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
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },

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
