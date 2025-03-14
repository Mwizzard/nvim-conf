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
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
    {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        require("nvim-tree").setup({
          view = {
          width = 20,
          side = "left",
          }
        })
      end
    },

    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    { 
    "danymat/neogen", 
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*" 
    },
    {
      "stevearc/overseer.nvim",
      config = function()
      require("overseer").setup()
    end
  }

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
require("telescope").setup {
  extensions = {
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
}

require("telescope").load_extension "file_browser"
require('neogen').generate()
local builtin = require("telescope.builtin")
local config = require("nvim-treesitter.configs")
config.setup({
	ensure_installed = {"lua", "vim", "cpp", "python", "java", "bash", "doxygen", "asm"},
	highlight = {enable = true},
	indent = {enable = true},
})
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>")
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<leader><Tab>", ":wincmd w<CR>", { noremap = true, silent = true })
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

require("overseer").setup()

local function run_all_files()
    local overseer = require("overseer")
    local files = vim.fn.glob("*", false, true) -- Get all files in the directory
    local tasks = {}
  task_list = {
    direction = "right",  -- Options: right, left, top, bottom, floating
    min_height = 9,
    max_height = 19,
  }

    for _, file in ipairs(files) do
        local output_binary = file:gsub("%.cpp$", ""):gsub("%.c$", "")

        if file:match("%.c$") then
            local compile_task = overseer.new_task({
                name = "Compile " .. file,
                cmd = { "gcc", file, "-o", output_binary },
                cwd = vim.fn.getcwd(),
                components = { "default", "on_output_quickfix", "on_complete_notify" },
            })
            table.insert(tasks, compile_task)

            local run_task = overseer.new_task({
                name = "Run " .. file,
                cmd = { "./" .. output_binary },
                cwd = vim.fn.getcwd(),
                components = { "default", "on_output_quickfix", "on_complete_notify" },
            })
            table.insert(tasks, run_task)

elseif file:match("%.cpp$") then
  local compile_task = overseer.new_task({
      name = "Compile " .. file,
      cmd = { "g++", file, "-o", output_binary },
      cwd = vim.fn.getcwd(),
      components = { "default", "on_output_quickfix", "on_complete_notify" },
  })

  local absolute_output = vim.fn.getcwd() .. "/" .. output_binary
  local run_task = overseer.new_task({
      name = "Run " .. file,
      cmd = { absolute_output },
      cwd = vim.fn.getcwd(),
      components = { "default", "on_output_quickfix", "on_complete_notify" },
      depends = { compile_task },  -- Ensure it only runs after compiling
  })

  table.insert(tasks, compile_task)
  table.insert(tasks, run_task)
        elseif file:match("%.py$") then
            local task = overseer.new_task({
                name = "Run " .. file,
                cmd = { "python3", file },
                cwd = vim.fn.getcwd(),
                components = { "default", "on_output_quickfix" },
            })
            table.insert(tasks, task)
        elseif file:match("%.js$") then
            local task = overseer.new_task({
                name = "Run " .. file,
                cmd = { "node", file },
                cwd = vim.fn.getcwd(),
                components = { "default", "on_output_quickfix" },
            })
            table.insert(tasks, task)
        elseif file:match("%.sh$") then
            local task = overseer.new_task({
                name = "Run " .. file,
                cmd = { "bash", file },
                cwd = vim.fn.getcwd(),
                components = { "default", "on_output_quickfix" },
            })
            table.insert(tasks, task)
        elseif file:match("%.java$") then
            local compile_task = overseer.new_task({
                name = "Compile " .. file,
                cmd = { "env", "PATH=" .. os.getenv("PATH"), "javac", file },
                cwd = vim.fn.getcwd(),
                components = { "default", "on_output_quickfix", "on_complete_notify" },
            })
            table.insert(tasks, compile_task)

            local run_task = overseer.new_task({
                name = "Run " .. file,
                cmd = { "env", "PATH=" .. os.getenv("PATH"), "java", output_binary },
                cwd = vim.fn.getcwd(),
                components = { "default", "on_output_quickfix", "on_complete_notify" },
            })
            table.insert(tasks, run_task)
        else
            goto continue
        end

        ::continue::
    end

    for _, task in ipairs(tasks) do
        task:start()
    end

    if #tasks == 0 then
        print("No runnable files found in current directory")
    end
end

vim.keymap.set("n", "<leader>r", run_all_files, { desc = "Compile and run all files in CWD with overseer" })
vim.keymap.set("n", "<Leader>o", ":OverseerOpen<CR>", { desc = "Open task output" })








vim.cmd.colorscheme "catppuccin"
