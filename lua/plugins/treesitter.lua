return {
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
	    ensure_installed = {"lua", "vim", "cpp", "python", "java", "bash", "doxygen", "nasm"},
	    highlight = {enable = true},
	    indent = {enable = true},
      })
    end
      
}

