return {
  "nvim-neotest/neotest",
  dependencies = {
    "lawrence-laz/neotest-zig", -- Installation
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "antoinemadec/FixCursorHold.nvim",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-zig"), -- Registration
      },
    })
  end,
}
