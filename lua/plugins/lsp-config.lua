return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",

    config = function()
      require("mason-lspconfig").setup({
        auto_install = true
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    local lspconfig = require("lspconfig")
    require('lspconfig').harper_ls.setup {
     settings = {
          ["harper-ls"] = {
            linters = {
              SentenceCapitalization = false,
              SpellCheck = false
          }
        }
      }
    }
    lspconfig.clangd.setup({capabilities = capabilities})
    lspconfig.lua_ls.setup({capabilities = capabilities})
    lspconfig.ast_grep.setup({capabilities = capabilities})
    lspconfig.textlsp.setup({capabilities = capabilities})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})

    if vim.lsp.buf.code_action then
      vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  end
  }
}
