local lualine = require("lualine")
-- TODO: Remove in the future. Maybe I'll need these icons
-- navic.setup({
--   icons = {
--     File = " ",
--     Module = " ",
--     Namespace = " ",
--     Package = " ",
--     Class = " ",
--     Method = " ",
--     Property = " ",
--     Field = " ",
--     Constructor = " ",
--     Enum = " ",
--     Interface = " ",
--     Function = " ",
--     Variable = " ",
--     Constant = " ",
--     String = " ",
--     Number = " ",
--     Boolean = " ",
--     Array = " ",
--     Object = " ",
--     Key = " ",
--     Null = " ",
--     EnumMember = " ",
--     Struct = " ",
--     Event = " ",
--     Operator = " ",
--     TypeParameter = " ",
--   },
--   highlight = true,
-- })

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    theme = "auto",
  },
  sections = {
    -- these are to remove the defaults
    -- lualine_a = {},
    lualine_b = {
      {
        "branch",
        -- icon = "",
        icon = "",
        separator = "",
      },
      {
        "diff",
        -- Is it me or the symbol for modified us really weird
        symbols = { added = " ", modified = " ", removed = " " },
        separator = false,
        cond = conditions.hide_in_width,
      },
    },
    lualine_c = {
      { "%=", separator = "" },
      {
        "filename",
        cond = conditions.buffer_not_empty,
        filestatus = true,
        path = 3,
        symbols = {
          modified = "[+]", -- Text to show when the file is modified.
          readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
          unnamed = "[No Name]", -- Text to show for unnamed buffers.
          newfile = "[New]", -- Text to show for newly created file before first write
        },
        separator = "",
      },
    },
    lualine_x = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic", "nvim_lsp" },
        sections = { "error", "warn", "info", "hint" },
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
        colored = true,
        separator = "",
      },
      {
        "fileformat",
        fmt = string.upper,
        separator = "",
      },
      {
        "o:encoding", -- option component same as &encoding in viml
        cond = conditions.hide_in_width,
        separator = "",
      },
      {
        "filetype",
      },
    },
    lualine_y = {
      { "filesize", cond = conditions.buffer_not_empty, separator = "" },
      { "progress", separator = "" },
    },
    lualine__z = {
      { "location", separator = "" },
    },
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
  winbar = {},
  -- winbar = { lualine_c = { { navic.get_location, cond = navic.is_available } } },
  inactive_winbar = {},
}

-- Now don't forget to initialize lualine
lualine.setup(config)
