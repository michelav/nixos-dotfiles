local wk = require('which-key')

local opts = {
  mode = "n",
  prefix = "",
  silent = true,
  noremap = true,
  nowait = true,
}

wk.register({
  ["<leader>]"] = { "<cmd>bn<cr>", "[BUFFER] Go previous buffer" },
  ["<leader>["] = { "<cmd>bp<cr>", "[BUFFER] Go next buffer" },
  ["<leader>q"] = { "<cmd>bd<cr>", "[BUFFER] Close current buffer" },

  --    ["<c-n>"] = { "<cmd>NvimTreeToggle<cr> <cmd>NvimTreeRefresh<cr>", "[NVIMTREE] Toggle" },

  ["<leader>t"] = {
    name = "[TELESCOPE]",
    f = { "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", "[TELESCOPE] Find File" },
    g = { "<cmd>Telescope live_grep<cr>", "[TELESCOPE] Find File by grep" },
    b = { "<cmd>Telescope buffers<cr>", "[TELESCOPE] Find buffers" },
    h = { "<cmd>Telescope help_tags<cr>", "[TELESCOPE] Help tags" },
    m = { "<cmd>Telescope marks<cr>", "[TELESCOPE] Marks" },
  },

  ["<leader>g"] = {
    name = "[GITSIGNS]",
    s = { "<cmd>Gitsigns toggle_signs<cr>", "[GITSIGNS] Toggle signs" },
    h = { "<cmd>Gitsigns preview_hunk<cr>", "[GITSIGNS] Preview hunk" },
    d = { "<cmd>Gitsigns diffthis<cr>", "[GITSIGNS] Show diff" },
  },
}, opts)

wk.setup {}

