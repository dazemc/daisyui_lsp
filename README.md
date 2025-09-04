```lua
return {
  'dazemc/daisyui_lsp',
  ft = { 'dart', 'html', 'css', 'js' },                               -- Lazy load
  dependencies = {
    { 'MeanderingProgrammer/render-markdown.nvim', optional = true }, -- for hover docs rendering
  },
  config = function()
    local lspconfig = require('lspconfig')
    local configs = require('lspconfig.configs')
    local lsp_exe = vim.fn.stdpath("data") .. "/lazy/daisyui_lsp/bin/daisyui_lsp.exe"


    -- Define the server if not already defined
    if not configs.daisyui_lsp then
      configs.daisyui_lsp = {
        default_config = {
          name = 'daisyui_lsp',
          cmd = { lsp_exe },
          filetypes = { 'dart', 'html', 'css', 'js' }, -- Choose your attached filetypes here
          root_dir = lspconfig.util.root_pattern('pubspec.yaml', '.git', 'tailwind.config.js'),
          settings = {
            daisyui_lsp = {},
          },
        },
      }
    end

    -- Setup the LSP server
    lspconfig.daisyui_lsp.setup {
      capabilities = capabilities, -- Ensure 'capabilities' is defined elsewhere
      on_attach = function(client, bufnr)
        -- Optional keymaps can go here
      end,
      settings = {
        daisyui_lsp = {},
      },
    }
  end,
}
```
