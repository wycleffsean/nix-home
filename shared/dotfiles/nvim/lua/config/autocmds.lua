-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Neotest - run file on save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.zig" },
  callback = function(_)
    -- neotest run file
    -- https://github.com/LazyVim/LazyVim/blob/68ff818a5bb7549f90b05e412b76fe448f605ffb/lua/lazyvim/plugins/extras/test/core.lua#L110C34-L110C80
    require("neotest").run.run(vim.fn.expand("%"))
  end,
})
