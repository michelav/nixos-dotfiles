-- Feline statusline definition.
--
-- Note: This statusline does not define any colors. Instead the statusline is
-- built on custom highlight groups that I define. The colors for these
-- highlight groups are pulled from the current colorscheme applied. Check the
-- file: `lua/eden/modules/ui/colors.lua` to see how they are defined.

require("plugins.configs.colors")
local u = require("plugins.configs.feline.utils")
local fmt = string.format

-- "┃", "█", "", "", "", "", "", "", "●"

local get_diag = function(str)
  local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[str] })
  local count = #diagnostics

  return (count > 0) and " " .. count .. " " or ""
end

local function vi_mode_hl()
  return u.vi.colors[vim.fn.mode()] or "SLViBlack"
end

local function vi_sep_hl()
  return u.vi.sep[vim.fn.mode()] or "SLBlack"
end

local c = {
  vimode = {
    provider = function()
      return string.format(" %s ", u.vi.text[vim.fn.mode()])
    end,
    hl = vi_mode_hl,
    right_sep = { str = " ", hl = vi_sep_hl },
  },
  gitbranch = {
    provider = "git_branch",
    icon = " ",
    hl = "SLGitBranch",
    right_sep = { str = "  ", hl = "SLGitBranch" },
    enabled = function()
      return vim.b.gitsigns_status_dict ~= nil
    end,
  },
  file_type = {
    provider = function()
      return fmt(" %s ", vim.bo.filetype:upper())
    end,
    hl = "SLAlt",
  },
  fileinfo = {
    provider = { name = "file_info", opts = { type = "relative" } },
    hl = "SLAlt",
    left_sep = { str = " ", hl = "SLAltSep" },
    right_sep = { str = " ", hl = "SLAltSep" },
  },
  file_enc = {
    provider = function()
      local os = u.icons[vim.bo.fileformat] or ""
      return fmt(" %s %s ", os, vim.bo.fileencoding)
    end,
    hl = "StatusLine",
    left_sep = { str = u.icons.left_filled, hl = "SLAltSep" },
  },
  cur_position = {
    provider = function()
      -- TODO: What about 4+ diget line numbers?
      return fmt(" %3d:%-2d ", unpack(vim.api.nvim_win_get_cursor(0)))
    end,
    hl = vi_mode_hl,
    left_sep = { str = u.icons.left_filled, hl = vi_sep_hl },
  },
  cur_percent = {
    provider = function()
      return " " .. require("feline.providers.cursor").line_percentage() .. "  "
    end,
    hl = vi_mode_hl,
    left_sep = { str = u.icons.left, hl = vi_mode_hl },
  },
  default = { -- needed to pass the parent StatusLine hl group to right hand side
    provider = "",
    hl = "StatusLine",
  },
  lsp_status = {
    provider = function()
      return " "
      -- return require("lsp-status").status()
    end,
    hl = "SLStatus",
    left_sep = { str = "", hl = "SLStatusBg", always_visible = true },
    right_sep = { str = "", hl = "SLErrorStatus", always_visible = true },
  },
  lsp_error = {
    provider = function()
      return get_diag("ERROR")
    end,
    hl = "SLError",
    right_sep = { str = "", hl = "SLWarnError", always_visible = true },
  },
  lsp_warn = {
    provider = function()
      return get_diag("WARN")
    end,
    hl = "SLWarn",
    right_sep = { str = "", hl = "SLInfoWarn", always_visible = true },
  },
  lsp_info = {
    provider = function()
      return get_diag("INFO")
    end,
    hl = "SLInfo",
    right_sep = { str = "", hl = "SLHintInfo", always_visible = true },
  },
  lsp_hint = {
    provider = function()
      return get_diag("HINT")
    end,
    hl = "SLHint",
    right_sep = { str = "", hl = "SLFtHint", always_visible = true },
  },

  in_fileinfo = {
    provider = "file_info",
    hl = "StatusLine",
  },
  in_position = {
    provider = "position",
    hl = "StatusLine",
  },
}

local active = {
  { -- left
    c.vimode,
    c.gitbranch,
    c.fileinfo,
    c.default, -- must be last
  },
  { -- right
    c.lsp_status,
    c.lsp_error,
    c.lsp_warn,
    c.lsp_info,
    c.lsp_hint,
    c.file_type,
    c.file_enc,
    c.cur_position,
    c.cur_percent,
  },
}

local inactive = {
  { c.in_fileinfo }, -- left
  { c.in_position }, -- right
}

-- -- Define autocmd that generates the highlight groups from the new colorscheme
-- -- Then reset the highlights for feline
-- edn.aug.FelineColorschemeReload = {
--   {
--     { "SessionLoadPost", "ColorScheme" },
--     function()
--       require("eden.modules.ui.feline.colors").gen_highlights()
--       -- This does not look like it is required. If this is called I see the ^^^^^^ that
--       -- seperates the two sides of the bar. Since the entire config uses highlight groups
--       -- all that is required is to redefine them.
--       -- require("feline").reset_highlights()
--     end,
--   },
-- }

require("feline").setup({
  components = { active = active, inactive = inactive },
  highlight_reset_triggers = {},
  force_inactive = {
    filetypes = {
      "NvimTree",
      "packer",
      "dap-repl",
      "dapui_scopes",
      "dapui_stacks",
      "dapui_watches",
      "dapui_repl",
      "LspTrouble",
      "qf",
      "help",
    },
    buftypes = { "terminal" },
    bufnames = {},
  },
  disable = {
    filetypes = {
      "dashboard",
      "startify",
    },
  },
})

