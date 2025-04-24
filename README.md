WIP (Code Completion ✅)
```lua
local configs = require 'lspconfig.configs'

      if not configs.daisyui_lsp then
        configs.daisyui_lsp = {
          default_config = {
            name = 'daisyui_lsp',
            cmd = { '/home/daze/Git/daisyui_lsp/bin/daisyui_lsp.exe' },
            filetypes = { 'dart' }, -- Your existing filetypes
            root_dir = require('lspconfig').util.root_pattern('pubspec.yaml', '.git'),
            settings = {
              daisyui_lsp = {
                -- Any default server settings
              },
            },
          },
        }
      end

      require('lspconfig').daisyui_lsp.setup {
        capabilities = capabilities, -- Assuming 'capabilities' is defined earlier
        on_attach = function(client, bufnr)
          local opts = { noremap = true, silent = true }
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          -- Keep other on_attach logic from your global LspAttach if desired,
          -- or move specific mappings here. The global LspAttach often handles
          -- generic mappings like rename, code action etc.
          print 'DaisyUI LSP attached' -- This print will now appear if it attaches
        end,
        settings = {
          daisyui_lsp = {
            -- Specific settings for this setup call
          },
        },
      }
```
