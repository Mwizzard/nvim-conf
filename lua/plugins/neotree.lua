return {
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
    vim.keymap.set('n', '<leader>e', ':Neotree filesystem reveal left<CR>',{ noremap = true, silent = true } ),
    vim.keymap.set("n", "<leader><Tab>", ":wincmd w<CR>",{ noremap = true, silent = true } )
}
  
}
