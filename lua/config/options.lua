-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.modeline = true
vim.opt.modelines = 5

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 2 -- Length of a tab character in spaces.
vim.opt.softtabstop = 2 -- Length of a tab entered in insert mode
vim.opt.shiftwidth = 2 -- Length of an autoindent
vim.opt.expandtab = true -- Insert spaces instead of tab characters
vim.opt.autoindent = true -- Maintain indent from previous line

vim.g.mapleader = ","

vim.g.autoformat = false -- disable autoformat

-- Show search results by default, but hide them with ,<space>
-- (disabled this because it conflicts with telescope bindings which I prefer)
--vim.opt.hlsearch = true
--vim.api.nvim_set_keymap("n", "<leader><space>", ":nohlsearch<CR>:match<CR>", { noremap = true })

-- Escape insert mode in terminal with ESC
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Highlight word under cursor without moving to next match
vim.api.nvim_set_keymap(
  "n",
  "<leader>#",
  [[:<C-u>let @/ = expand('<cword>')<CR>:<C-u>set hlsearch<CR>]],
  { noremap = true }
)

-- Repeat last macro
vim.api.nvim_set_keymap("n", "<leader>,", "@@", { noremap = true })

-- Semi-pgup/down
vim.api.nvim_set_keymap("n", "<S-PageUp>", "10k", { noremap = true })
vim.api.nvim_set_keymap("n", "<S-PageDown>", "10j", { noremap = true })

-- Gitsigns hunk navigation
vim.api.nvim_set_keymap("n", "<leader>ghn", ":Gitsigns next_hunk<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ghP", ":Gitsigns prev_hunk<CR>", { noremap = true })

-- Java remote debugging
vim.api.nvim_create_user_command("JavaAddRemoteDebugTarget", function (opts)
  local usage = "Usage: JavaAddRemoteDebugTarget <host> <port>"
  local args = vim.split(opts.args, " ")

  if #args ~= 2 then
    print(usage)
    return
  end

  local host, port = args[1], args[2]
  local remote_config = {
    type = 'java',
    request = 'attach',
    name = "Debug (Attach) - Remote - "..host..":"..port,
    hostName = host,
    port = tonumber(port)
  }

  if require("dap").configurations.java == nil then
    print("Dap not loaded for java, aborting")
    return
  end

  table.insert(require("dap").configurations.java, remote_config)
  print("Added "..remote_config.name)
end, { nargs = "*" })

-- Highlighting (to be replaced with platladan stuff)
-- Table to keep track of highlighted words and their associated groups
local highlighted_words = {}
-- List of colors to cycle through
local colors = {
  { name = "Yellow", color = "Yellow" },
  { name = "Green", color = "Green" },
  { name = "Cyan", color = "Cyan" },
  { name = "Magenta", color = "Magenta" },
  { name = "Red", color = "Red" },
  { name = "Blue", color = "Blue" }
}
-- Index to keep track of the current color
local current_color_index = 1

-- Function to toggle highlighting for a given range of text
function ToggleHighlightRange()
  -- Get the visually selected text or the motion text
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  -- Ensure valid positions are retrieved
  if not start_pos or not end_pos then
    print("No valid selection or motion.")
    return
  end

  -- Retrieve lines in the range
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]
  local lines = vim.fn.getline(start_line, end_line)

  -- Extract the text based on start and end positions
  local text = ""
  if #lines == 0 then
    print("No text found in the selection.")
    return
  elseif #lines == 1 then
    text = lines[1]:sub(start_col, end_col)
  else
    text = lines[1]:sub(start_col) .. table.concat(lines, "\n", 2, #lines - 1) .. lines[#lines]:sub(1, end_col)
  end

  -- Ensure text is not empty
  if text == "" then
    print("Empty text selection.")
    return
  end

  -- Check if the text is already highlighted
  if highlighted_words[text] then
    -- If highlighted, clear the highlight and remove it from the table
    vim.cmd("syntax clear " .. highlighted_words[text].group)
    highlighted_words[text] = nil
    print("Removed highlight for text: " .. text)
  else
    -- Get the current color from the list
    local color = colors[current_color_index]
    -- Create a unique highlight group name based on the text
    local group_name = "Highlight_" .. text:gsub("[^%w]", "_") -- Sanitize group name

    -- Define the syntax match and highlight command
    vim.cmd("syntax match " .. group_name .. " /\\V" .. text:gsub("/", "\\/") .. "/")
    vim.cmd("highlight " .. group_name .. " ctermfg=" .. color.color .. " guifg=" .. color.color)

    -- Add the text to the highlighted_words table with the group name and color
    highlighted_words[text] = { group = group_name, color = color.color }

    print("Added highlight for text: " .. text .. " with color: " .. color.color)

    -- Update the color index for round-robin
    current_color_index = (current_color_index % #colors) + 1
  end
end

-- Function to clear all highlights
function ClearAllHighlights()
  for text, data in pairs(highlighted_words) do
    vim.cmd("syntax clear " .. data.group)
  end
  highlighted_words = {} -- Reset the table
  print("Cleared all highlights.")
end

function DumpAllHighlights()
  vim.print(highlighted_words)
end

-- Function to jump to the next instance of any highlighted word
function JumpToNextHighlight(back)
    if vim.tbl_isempty(highlighted_words) then
        print("No highlighted words to jump to.")
        return
    end

    -- Create a search pattern from all highlighted words
    local patterns = {}
    for word, _ in pairs(highlighted_words) do
        table.insert(patterns, "\\V" .. word:gsub("/", "\\/")) -- Escape any slashes
    end
    local search_pattern = "\\(" .. table.concat(patterns, "\\|") .. "\\)"

    -- Perform the search
    local found = vim.fn.search(search_pattern, "W"..(back and "b" or "")) -- 'W' wraps around the document
    if found == 0 then
        print("No more instances of highlighted words.")
    end
end

-- Map a key to toggle highlight with a motion (e.g., <leader>h followed by a motion)
vim.api.nvim_set_keymap("v", "<leader>h", ":lua ToggleHighlightRange()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>h", ":lua JumpToNextHighlight()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>H", ":lua JumpToNextHighlight(true)<CR>", { noremap = true, silent = true })

-- Disable animations...
vim.g.snacks_animate = false
