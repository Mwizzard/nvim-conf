--vim.o.guifont = "JetBrainsMono Nerd Font:h50"
vim.cmd.colorscheme "catppuccin"

vim.g.mapleader = " "

vim.opt.tabstop = 2        
vim.opt.shiftwidth = 2     
vim.opt.expandtab = true   
vim.opt.softtabstop = 2   
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

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



