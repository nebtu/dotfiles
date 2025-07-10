return {
	{ -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
		-- for complete functionality (language features)
		"quarto-dev/quarto-nvim",
		ft = { "quarto" },
		dev = false,
		opts = {
			lspFeatures = {
				languages = {
					--"r",
					"python",
					"julia",
					"bash",
					"lua",
					"html",
					"dot",
					"javascript",
					"typescript",
					"ojs",
					"lua",
				},
			},
			codeRunner = {
				enabled = true,
				default_method = "slime",
			},
		},
		dependencies = {
			-- for language features in code cells
			-- configured in lua/plugins/lsp.lua and
			-- added as a nvim-cmp source in lua/plugins/completion.lua
			"jmbuhr/otter.nvim",
		},
	},
	{ -- send code from python/r/qmd documets to a terminal or REPL
		-- like ipython, R, bash
		"jpalardy/vim-slime",
		lazy = false,
		init = function()
			vim.g.slime_target = "neovim"
			vim.g.slime_no_mappings = true
			vim.g.slime_python_ipython = 1
		end,
		config = function()
			vim.g.slime_input_pid = false
			vim.g.slime_suggest_default = true
			vim.g.slime_menu_config = false
			vim.g.slime_neovim_ignore_unlisted = true

			local function mark_terminal()
				local job_id = vim.b.terminal_job_id
				vim.print("job_id: " .. job_id)
			end

			local function set_terminal()
				vim.fn.call("slime#config", {})
			end
			vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
			vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
		end,
		keys = {
			{ "Q", "<Plug>SlimeMotionSend", mode = "n", desc = "Slime Motion Send" },
			{ "QQ", "<Plug>SlimeLineSend", mode = "n", desc = "Slime Line Send" },
			{ "Q", "<Plug>SlimeRegionSend", mode = "x", desc = "Slime Region Send" },
			{ "<CR-Q>", "<Plug>SlimeCellSend", mode = "n", desc = "Slime Cell Send" },
		},
	},
}
