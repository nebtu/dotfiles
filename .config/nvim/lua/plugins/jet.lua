return {
	{ -- jupyter kernels (R via ark, python via ipykernel) as repls
		"wurli/jet.nvim",
		lazy = false,
		dependencies = {
			"wurli/jet.ark",
			"wurli/jet.ipy",
		},
		init = function()
			-- no image support in alacritty: show matplotlib plots in native windows
			vim.env.MPLBACKEND = "TkAgg"
		end,
		config = function()
			require("jet").setup({})

			-- jet.ark errors on setup if the ark binary is missing. The AUR package
			-- (ark-kernel-git-bin) names it ark-kernel; plain `ark` may be KDE's archiver
			local ark_bin = vim.fn.exepath("ark-kernel")
			if ark_bin ~= "" then
				require("jet.ark").setup({ ark_binary_path = ark_bin })
				-- ark sets its own viewer/graphics device during startup, so override them
				-- once the kernel is connected (ark's startup_file runs too early)
				local session_file = vim.fn.stdpath("config") .. "/r/ark-session.R"
				require("jet").hooks.on_lua_client_start.ark_session = function(k)
					if k.subclass == "ark" then
						k:send_lua(string.format("source(%q)", session_file), true)
					end
				end
			else
				vim.notify("ark-kernel not found, skipping jet.ark setup", vim.log.levels.WARN)
			end

			-- jet.ark registers ark's LSP with root_dir ".", which reaches ark as "/." and makes
			-- it index the whole filesystem. Point it at the project instead.
			vim.lsp.config("*", {
				before_init = function(params, config)
					if not (config.name or ""):match("^ark_") then
						return
					end
					local root = vim.fs.root(0, { ".git", ".Rproj", "DESCRIPTION", ".Rprofile" }) or vim.fn.getcwd()
					params.rootPath = root
					params.rootUri = vim.uri_from_fname(root)
					params.workspaceFolders = { { uri = params.rootUri, name = vim.fs.basename(root) } }
				end,
			})

			-- otter only uses the first response from the servers attached to its hidden
			-- buffers, and jet's repl completion server (empty outside the repl) always
			-- beats ark. Keep it off otter's R buffers (its root_dir is fixed, so it can
			-- only be detached after attaching)
			local function is_otter_r(buf)
				return vim.api.nvim_buf_get_name(buf):match("%.otter%.[rR]$") ~= nil
			end
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("jet-otter-r", { clear = true }),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not (client and is_otter_r(ev.buf)) then
						return
					end
					if client.name:match("^jet_.*%-%-%-repl%-%-%-") then
						vim.schedule(function()
							vim.lsp.buf_detach_client(ev.buf, client.id)
						end)
					end
				end,
			})

			require("jet.ipy").setup()

			local api = require("jet.api")
			local repl = require("config.repl")

			-- jet finds expressions/languages via treesitter, but treesitter isn't started
			-- for r/python buffers here, so parse (incl. injections) on demand
			local function ensure_parsed()
				pcall(function()
					vim.treesitter.get_parser(0):parse(true)
				end)
			end
			local send_motion = api.handle_motion(function(range, filetype)
				local code = range:code({ comments = false })
				if code and filetype then
					repl.send(filetype, code)
				end
			end)

			-- send motion / selection to the repl matching the language at the cursor
			vim.keymap.set({ "n", "x" }, "Q", function()
				ensure_parsed()
				return send_motion()
			end, { desc = "Send to repl (Jet)", expr = true })
			vim.keymap.set("n", "QQ", "Q_", { remap = true, desc = "Send line to repl (Jet)" })

			vim.keymap.set({ "x", "o" }, "ie", function()
				ensure_parsed()
				local expr = api.get_expr()
				if not expr then
					local pos = api.next_expr_boundary({ current_ok = false, boundary = "start" })
					expr = pos and api.get_expr(pos)
				end
				if expr then
					expr:textobject()
				end
			end, { desc = "textobject (jet): [i]n [e]xpression" })

			vim.keymap.set("n", "]e", function()
				ensure_parsed()
				local pos = api.next_expr_boundary({ direction = 1, boundary = "start" })
				if pos then
					vim.fn.cursor(pos:to_cursor())
				end
			end, { desc = "Next expression" })
			vim.keymap.set("n", "[e", function()
				ensure_parsed()
				local pos = api.next_expr_boundary({ direction = -1, boundary = "start" })
				if pos then
					vim.fn.cursor(pos:to_cursor())
				end
			end, { desc = "Previous expression" })

			-- which-key group is registered in lua/config/keymap.lua
			vim.keymap.set("n", "<leader>jj", "<cmd>Jet<cr>", { desc = "[j]et kernel manager" })
			vim.keymap.set("n", "<leader>jr", repl.toggle("r"), { desc = "toggle [r] repl" })
			vim.keymap.set("n", "<leader>jp", repl.toggle("python"), { desc = "toggle [p]ython repl" })
			vim.keymap.set("n", "<leader>jv", "<cmd>ArkVars<cr>", { desc = "R [v]ariables" })
			vim.keymap.set("n", "<leader>jh", ":ArkHelp ", { desc = "R [h]elp" })
			vim.keymap.set("n", "<leader>ji", repl.interrupt, { desc = "[i]nterrupt kernel" })
		end,
	},
}
