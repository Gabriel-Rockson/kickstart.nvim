-- stylua: ignore start
---@diagnostic disable: missing-fields
-- stylua: ignore end
--
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-go',
    'nvim-neotest/neotest-jest',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-jest' {
          -- Use pnpm to run tests
          jestCommand = 'pnpm test --',
          -- Or if you're using turbo
          -- jestCommand = "pnpm turbo test --",

          -- Detect the project root
          root_dir = function()
            -- This will look for the nearest package.json
            return require('neotest-jest.util').find_package_json_ancestor()
          end,

          -- Handle workspace packages
          cwd = function(path)
            -- Find the workspace root based on package.json
            return require('neotest-jest.util').find_package_json_ancestor(path)
          end,

          -- Configure jest for your workspace
          jestConfigFile = function(path)
            -- Look for jest.config.js/ts in the package directory
            local pkg_root = require('neotest-jest.util').find_package_json_ancestor(path)
            local config_files = {
              'jest.config.ts',
              'jest.config.js',
            }
            for _, filename in ipairs(config_files) do
              local config_path = pkg_root .. '/' .. filename
              if vim.fn.filereadable(config_path) == 1 then
                return config_path
              end
            end
            -- Return default if no config file found
            return 'jest.config.ts'
          end,

          -- Environment variables
          env = {
            CI = true,
            NODE_ENV = 'test',
          },
        },
      },
    }

    -- Keymaps
    vim.keymap.set('n', '<leader>mr', function()
      require('neotest').run.run { strategy = 'integrated' }
    end, { desc = 'Run nearest test' })

    vim.keymap.set('n', '<leader>mf', function()
      require('neotest').run.run(vim.fn.expand '%')
    end, { desc = 'Run current file' })

    vim.keymap.set('n', '<leader>ms', function()
      require('neotest').summary.toggle()
    end, { desc = 'Toggle test summary' })

    vim.keymap.set('n', '<leader>mo', function()
      require('neotest').output.open()
    end, { desc = 'Show test output' })

    vim.keymap.set('n', '<leader>mp', function()
      require('neotest').output_panel.open()
    end, { desc = 'Show output panel' })

    vim.keymap.set('n', '<leader>mS', function()
      require('neotest').run.stop()
    end, { desc = 'Stop test run' })

    vim.keymap.set('n', '<leader>mw', function()
      require('neotest').run.run {
        -- Add the --watch flag to the jest command
        args = { '--watch' },
      }
    end, { desc = 'Run nearest test in watch mode' })

    -- Additional useful mappings for monorepo
    vim.keymap.set('n', '<leader>mW', function()
      -- Run all tests in the current workspace package
      local path = vim.fn.expand '%:p:h'
      local pkg_root = require('neotest-jest.util').find_package_json_ancestor(path)
      require('neotest').run.run(pkg_root)
    end, { desc = 'Run all tests in current package' })
  end,
}
