  return{ 
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000,
    config = function()
      theme = "machiato"
      vim.cmd.colorscheme "catppuccin"
    end
}

