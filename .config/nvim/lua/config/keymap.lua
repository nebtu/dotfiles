-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

local is_code_chunk = function()
	local current, _ = require("otter.keeper").get_current_language_context()
	if current then
		return true
	else
		return false
	end
end

--- Insert code chunk of given language
--- Splits current chunk if already within a chunk
--- @param lang string
local insert_code_chunk = function(lang)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
	local keys
	if is_code_chunk() then
		keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
	else
		keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
	end
	keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
	vim.api.nvim_feedkeys(keys, "n", false)
end

local insert_r_chunk = function()
	insert_code_chunk("r")
end

local insert_py_chunk = function()
	insert_code_chunk("python")
end

local insert_julia_chunk = function()
	insert_code_chunk("julia")
end

vim.keymap.set("n", "<c-i>", insert_r_chunk, { desc = "Insert R code chunk" })
vim.keymap.set("i", "<c-i>", insert_r_chunk, { desc = "Insert R code chunk" })
vim.keymap.set("n", "<leader>z", ":setlocal spell!<cr>", { desc = "Toggle spell checking" })

local function new_terminal(lang)
	vim.cmd("vsplit term://" .. lang)
end

local function new_terminal_python()
	new_terminal("python")
end

local function new_terminal_r()
	new_terminal("radian")
end

local function new_terminal_ipython()
	new_terminal("ipython --no-confirm-exit --no-autoindent")
end

local function new_terminal_julia()
	new_terminal("julia")
end

--- Show R dataframe in the browser
-- might not use what you think should be your default web browser
-- because it is a plain html file, not a link
-- see https://askubuntu.com/a/864698 for places to look for
local function show_r_table()
	local node = vim.treesitter.get_node({ ignore_injections = false })
	assert(node, "no symbol found under cursor")
	local text = vim.treesitter.get_node_text(node, 0)
	local cmd = [[call slime#send("DT::datatable(]] .. text .. [[)" . "\r")]]
	vim.cmd(cmd)
end

local function run_cell_continue()
	if is_code_chunk() then
		require("quarto.runner").run_cell()
	end
	local lnum = vim.fn.search("^```", "W")
	print(lnum)
	if lnum ~= 0 then
		vim.api.nvim_win_set_cursor(0, { lnum + 1, 0 })
	end
end

vim.keymap.set("n", "<c-cr>", run_cell_continue, { desc = "Run chunk and continue to next" })

require("which-key").add({
	{
		{ "<leader>c", group = "[c]ode / [c]ell / [c]hunk" },
		{ "<leader>ci", new_terminal_ipython, desc = "new [i]python terminal" },
		{ "<leader>cj", new_terminal_julia, desc = "new [j]ulia terminal" },
		{ "<leader>cp", new_terminal_python, desc = "new [p]ython terminal" },
		{ "<leader>cr", new_terminal_r, desc = "new [R] terminal" },
		{ "<leader>o", group = "[o]tter & c[o]de" },
		{ "<leader>oa", require("otter").activate, desc = "otter [a]ctivate" },
		{ "<leader>oc", "O# %%<cr>", desc = "magic [c]omment code chunk # %%" },
		{ "<leader>od", require("otter").activate, desc = "otter [d]eactivate" },
		{ "<leader>oj", insert_julia_chunk, desc = "[j]ulia code chunk" },
		{ "<leader>op", insert_py_chunk, desc = "[p]ython code chunk" },
		{ "<leader>or", insert_r_chunk, desc = "[r] code chunk" },
		{ "<leader>q", group = "[q]uarto" },
		{
			"<leader>qE",
			function()
				require("otter").export(true)
			end,
			desc = "[E]xport with overwrite",
		},
		{ "<leader>qa", ":QuartoActivate<cr>", desc = "[a]ctivate" },
		{ "<leader>qe", require("otter").export, desc = "[e]xport" },
		{ "<leader>qh", ":QuartoHelp ", desc = "[h]elp" },
		{ "<leader>qp", ":lua require'quarto'.quartoPreview()<cr>", desc = "[p]review" },
		{ "<leader>qu", ":lua require'quarto'.quartoUpdatePreview()<cr>", desc = "[u]pdate preview" },
		{ "<leader>qq", ":lua require'quarto'.quartoClosePreview()<cr>", desc = "[q]uiet preview" },
		{ "<leader>qr", group = "[r]un" },
		{ "<leader>qra", ":QuartoSendAll<cr>", desc = "run [a]ll" },
		{ "<leader>qrb", ":QuartoSendBelow<cr>", desc = "run [b]elow" },
		{ "<leader>qrr", ":QuartoSendAbove<cr>", desc = "to cu[r]sor" },
		{ "<leader>r", group = "[r] R specific tools" },
		{ "<leader>rt", show_r_table, desc = "show [t]able" },
	},
	{ mode = "n" },
})
