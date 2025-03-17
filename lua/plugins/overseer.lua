return {
      "stevearc/overseer.nvim",
      config = function()
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
      
    end

}

