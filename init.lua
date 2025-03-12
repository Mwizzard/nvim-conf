--vim.o.guifont = "JetBrainsMono Nerd Font:h50"
vim.g.mapleader = " "

vim.opt.tabstop = 2        
vim.opt.shiftwidth = 2     
vim.opt.expandtab = true   
vim.opt.softtabstop = 2   
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Function to toggle relative numbering dynamically
vim.api.nvim_create_autocmd({"BufEnter", "FocusGained", "InsertLeave", "WinEnter"}, {
  pattern = "*",
  callback = function()
    vim.opt.relativenumber = true
  end
})

vim.api.nvim_create_autocmd({"BufLeave", "FocusLost", "InsertEnter", "WinLeave"}, {
  pattern = "*",
  callback = function()
    vim.opt.relativenumber = false
  end
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys before loading lazy.nvim
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Plugin list
local plugins = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "nvim-lualine/lualine.nvim" },
      {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}
}

-- Setup lazy.nvim first
require("lazy").setup(plugins, {
  spec = {
    -- import your plugins
    { import = "plugins"},
  },
  --install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

--configure Catppuccin


require("catppuccin").setup({
  flavour = "macchiato",
  integrations = {
    treesitter = true,
    native_lsp = { enabled = true },
    cmp = true, 
    gitsigns = true,
    telescope = true, 
  }
})

local builtin = require("telescope.builtin")
local config = require("nvim-treesitter.configs")
config.setup({
	ensure_installed = {"lua", "vim", "cpp", "python", "java", "bash", "doxygen", "asm"},
	highlight = {enable = true},
	indent = {enable = true},
})
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
local function change_kitty_font_size(size)
  local handle = io.popen("kitty @ set-font-size " .. size)
  if handle then handle:close() end
end

function ZoomIn()
  change_kitty_font_size(tonumber(vim.g.kitty_font_size or 14) + 1)
  vim.g.kitty_font_size = vim.g.kitty_font_size + 1
end

function ZoomOut()
  change_kitty_font_size(math.max(8, tonumber(vim.g.kitty_font_size or 14) - 1))
  vim.g.kitty_font_size = vim.g.kitty_font_size - 1
end

-- zoom shortucts
vim.keymap.set("n", "<C-+>", ":lua ZoomIn()<CR>")
vim.keymap.set("n", "<C-->", ":lua ZoomOut()<CR>")


vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    change_kitty_font_size(14) 
  end
})

vim.cmd.colorscheme "catppuccin"

