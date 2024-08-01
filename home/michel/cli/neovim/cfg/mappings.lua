local wk = require("which-key")

wk.add({
  {
    "<leader>[",
    "<cmd>bp<cr>",
    desc = "[BUFFER] Go next buffer",
    nowait = true,
    remap = false,
  },
  {
    "<leader>]",
    "<cmd>bn<cr>",
    desc = "[BUFFER] Go previous buffer",
    nowait = true,
    remap = false,
  },
  { "<leader>g", group = "[GITSIGNS]",  nowait = true, remap = false },
  {
    "<leader>gd",
    "<cmd>Gitsigns diffthis<cr>",
    desc = "[GITSIGNS] Show diff",
    nowait = true,
    remap = false,
  },
  {
    "<leader>gh",
    "<cmd>Gitsigns preview_hunk<cr>",
    desc = "[GITSIGNS] Preview hunk",
    nowait = true,
    remap = false,
  },
  {
    "<leader>gs",
    "<cmd>Gitsigns toggle_signs<cr>",
    desc = "[GITSIGNS] Toggle signs",
    nowait = true,
    remap = false,
  },
  {
    "<leader>q",
    "<cmd>bd<cr>",
    desc = "[BUFFER] Close current buffer",
    nowait = true,
    remap = false,
  },
  { "<leader>t", group = "[TELESCOPE]", nowait = true, remap = false },
  {
    "<leader>tb",
    "<cmd>Telescope buffers<cr>",
    desc = "[TELESCOPE] Find buffers",
    nowait = true,
    remap = false,
  },
  {
    "<leader>tf",
    "<cmd>Telescope find_files hidden=true no_ignore=true<cr>",
    desc = "[TELESCOPE] Find File",
    nowait = true,
    remap = false,
  },
  {
    "<leader>tg",
    "<cmd>Telescope live_grep<cr>",
    desc = "[TELESCOPE] Find File by grep",
    nowait = true,
    remap = false,
  },
  { "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "[TELESCOPE] Help tags", nowait = true, remap = false },
  { "<leader>tm", "<cmd>Telescope marks<cr>",     desc = "[TELESCOPE] Marks",     nowait = true, remap = false },
})

wk.setup({})
