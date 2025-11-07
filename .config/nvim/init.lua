---------------------------------------------------
---- BASIC COMMANDS (That won't break things) -----
---------------------------------------------------
vim.opt.hidden = true
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.number = true

vim.keymap.set('n', '<C-k>', '15k')
vim.keymap.set('n', '<C-j>', '15j')
vim.keymap.set('n', '<C-l>', '20l')
vim.keymap.set('n', '<C-h>', '20h')
vim.keymap.set('v', '<C-k>', '15k')
vim.keymap.set('v', '<C-j>', '15j')
vim.keymap.set('v', '<C-l>', '20l')
vim.keymap.set('v', '<C-h>', '20h')
vim.keymap.set('', ';', ':')
vim.keymap.set('', ':', ';')
vim.keymap.set('i', 'jk', '<ESC>')
vim.keymap.set('i', 'kj', '<ESC>')
vim.keymap.set('n', 'e', 'o<ESC>k')
vim.keymap.set('n', 'E', 'O<ESC>j')
vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.opt.directory = '.'
vim.keymap.set('n', '<C-m>', '<C-o>') -- for working with tmux

vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- Cursorline
vim.o.cursorline = true
vim.o.cursorcolumn = true

-- Function to open a timestamped note
local function vimnote()
  local timestamp = os.date("%Y_%m_%d__%H_%M_%S")
  local filepath = string.format("%s/notes/note__%s.md", os.getenv("HOME"), timestamp)
  vim.cmd.edit(filepath)
end

-- Create the :Vimnote command
vim.api.nvim_create_user_command("Nvimnote", vimnote, {})

---------------------------------------------------
---------------- MANUAL LOADING -------------------
---------------------------------------------------
require("config.lazy")
require("custom.indentscope").setup()
require("custom.markdown")

-- needs to be set after lazy has been loaded
vim.cmd("colorscheme carbonfox")

-- needs to be set after the main theme
vim.api.nvim_set_hl(0, "CursorLine", {
  bg = "#262626",
})

---------------------------------------------------
--------------------- LSP -------------------------
---------------------------------------------------
vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')

-- Configure virtual text and signs
vim.diagnostic.config({
  virtual_text = {
    -- Show virtual text for errors and warnings
    severity = { min = vim.diagnostic.severity.WARN },
    --source = "always",
    prefix = "",
  },
  signs = true,
  update_in_insert = true, -- Update diagnostics while in insert mode
  float = {
    -- Options for the floating window when hovering
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

---------------------------------------------------
------------------- ORG MODE ----------------------
---------------------------------------------------
vim.keymap.set('n', '<C-b>a', ':Org agenda a<CR>')
vim.keymap.set('n', '<C-b>t', ':Org agenda t<CR>')
vim.keymap.set('n', '<C-b>m', ':Org agenda M<CR>')

---------------------------------------------------
------------------ TELESCOPE ----------------------
---------------------------------------------------
vim.keymap.set('n', 'ff', require('telescope.builtin').find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', 'fg', require('telescope.builtin').live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', 'fn', function()
	require('telescope.builtin').live_grep {
		cwd = "~/data/notes"
	}
end)

---------------------------------------------------
--------------------- DAP -------------------------
---------------------------------------------------
local dap = require('dap')

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      --command = 'path/to/virtualenvs/debugpy/bin/python',
      command = '/home/aclifton091/.d_venv/bin/python3',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";
    console = 'externalTerminal';
    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/home/aclifton091/.d_venv/bin/python3'
      end
    end;
  },
}

dap.defaults.fallback.external_terminal = {
  command = 'tmux',
  args = { 'split-window', '-h', '-d' },  -- change to '-v' if you prefer
}

vim.api.nvim_set_hl(0, "DapStopped", {
  --fg = "#2255FF",
  bg = "#222255",
  bold = true,
  italic = false,
  underline = false,
  reverse = false,
  link = nil, -- Link to another highlight group (e.g., "Comment")
})

vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

vim.keymap.set('n', 'dh', ':DapStepOut<CR>')
vim.keymap.set('n', 'dj', ':DapStepOver<CR>')
vim.keymap.set('n', 'dl', ':DapStepInto<CR>')
vim.keymap.set('n', 'dk', ':DapContinue<CR>')
--vim.keymap.set('n', 'dn', ':DapNew<CR>')
vim.keymap.set('n', 'dm', ':DapTerminate<CR>')
vim.keymap.set('n', 'db', ':DapToggleBreakpoint<CR>')

local widgets = require('dap.ui.widgets')

vim.keymap.set({'n', 'v'}, 'K', function()
  widgets.hover()   -- Hover popup for variable under cursor or selection
end, { desc = 'DAP hover popup' })

vim.keymap.set('n', '<leader>ds', function()
  widgets.centered_float(widgets.scopes)  -- Center popup showing current scopes/locals
end, { desc = 'DAP scopes float' })

vim.keymap.set('n', '<leader>df', function()
  widgets.centered_float(widgets.frames)  -- Popup stack frames
end, { desc = 'DAP frames float' })

vim.keymap.set('n', '<leader>dw', function()
  widgets.centered_float(widgets.watches) -- Popup watch expressions
end, { desc = 'DAP watches float' })

---------------------------------------------------
------------------ NEO TREE -----------------------
---------------------------------------------------
vim.keymap.set({ 'n', 'v' }, '<C-j>', '15j', { noremap = true })

-- Configure Neo-tree
require('neo-tree').setup({
  close_if_last_window = true,

  --  Tell Neo-tree: <C-j> = "open" (same as <CR>)
  window = {
    mappings = {
      ["<C-j>"] = "open",                 -- enter dir / open file
      ["<C-k>"] = "navigate_up",          -- pair with <C-k> to go up a dir
    },
  },

  filesystem = {
    follow_current_file = { enabled = true },
    hijack_netrw_behavior = "open_default",
    filtered_items = {
      visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },

  -- Auto-close tree after opening a file
  event_handlers = {
    {
      event = "file_opened",
      handler = function(_)
        require("neo-tree.command").execute({ action = "close" })
      end,
    },
  },
})

-- Toggle Neo-tree on the left & reveal current file
vim.keymap.set('n', '<C-f>', function()
  require('neo-tree.command').execute({
    source = 'filesystem',
    position = 'left',
    toggle = true,
    reveal = true,
  })
end, { desc = "Neo-tree (left, reveal)" })
