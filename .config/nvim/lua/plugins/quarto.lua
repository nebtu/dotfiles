return {
	{ -- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
		-- for complete functionality (language features)
		"quarto-dev/quarto-nvim",
		ft = { "quarto" },
		dev = false,
		init = function()
			-- otter-ls rewrites request params in place to point at its hidden buffers.
			-- Requests sent to all clients (e.g. blink's signature help) share one params
			-- table, so the other servers on the .qmd then get asked
			-- about a document they never opened. Give otter its own copy.
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("otter-copy-params", { clear = true }),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not (client and client.name:match("^otter%-ls") and not client._params_copied) then
						return
					end
					client._params_copied = true
					local request = client.rpc.request
					client.rpc.request = function(method, params, ...)
						return request(method, vim.deepcopy(params), ...)
					end
				end,
			})
		end,
		opts = {
			lspFeatures = {
				languages = {
					"r",
					"python",
					"julia",
					"bash",
					"lua",
					"html",
					"dot",
					"javascript",
					"typescript",
					"ojs",
				},
			},
			codeRunner = {
				enabled = true,
				default_method = function(cell, ignore_cols)
					require("config.repl").quarto_runner(cell, ignore_cols)
				end,
			},
		},
		dependencies = {
			-- for language features in code cells
			-- configured in lua/plugins/lsp.lua and
			-- added as a nvim-cmp source in lua/plugins/completion.lua
			"jmbuhr/otter.nvim",
		},
	},
	{ -- directly open ipynb files as quarto docuements
		-- and convert back behind the scenes
		-- Better (i think): use jupytext from the console, because that ties in
		-- with uv, and is more elegant in general
		"GCBallesteros/jupytext.nvim",
		opts = {
			custom_language_formatting = {
				python = {
					extension = "qmd",
					style = "quarto",
					force_ft = "quarto",
				},
				r = {
					extension = "qmd",
					style = "quarto",
					force_ft = "quarto",
				},
			},
		},
	},
}
