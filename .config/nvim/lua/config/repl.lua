-- Helpers for talking to jet.nvim kernels, shared by keymaps and the quarto runner
local M = {}

--- Run callback with the best kernel for a filetype.
--- Prefers the "current" kernel; otherwise jet picks (and starts, if inactive) one.
--- @param ft string
--- @param callback fun(k: jet.Kernel)
function M.with_kernel(ft, callback)
	local api = require("jet.api")
	api.list_kernels({ filetype = ft, current = true }, function(kernels)
		if kernels[1] then
			callback(kernels[1])
		else
			api.get_kernel({ filetype = ft }, callback)
		end
	end)
end

--- Wait (polling) until the kernel is connected and idle, then run callback.
--- Multi-line code sent while a kernel is still starting gets swallowed by the repl.
--- @param k jet.Kernel
--- @param callback fun()
local function when_ready(k, callback, tries)
	tries = tries or 100
	if k:status() == "connected" and k.execution_state == "idle" then
		vim.defer_fn(callback, 300)
	elseif tries > 0 then
		vim.defer_fn(function()
			when_ready(k, callback, tries - 1)
		end, 200)
	else
		vim.notify("[repl] kernel not ready, code not sent", vim.log.levels.WARN)
	end
end

--- Send code to the repl of the given filetype
--- @param ft string
--- @param code string | string[]
function M.send(ft, code)
	M.with_kernel(ft, function(k)
		if k:status() == "connected" then
			k:send_repl(code)
			return
		end
		k:term_open(function()
			when_ready(k, function()
				k:send_repl(code)
			end)
		end, false)
	end)
end

--- @param ft string
function M.toggle(ft)
	return function()
		require("jet.api").get_kernel({ filetype = ft }, function(k)
			k:term_toggle()
		end)
	end
end

function M.interrupt()
	require("jet.api").get_kernel({ filetype = true, status = { "connected" } }, function(k)
		k:interrupt()
	end)
end

--- Code runner for quarto-nvim (`codeRunner.default_method`)
--- @param cell CodeCell
function M.quarto_runner(cell, _)
	if cell.lang then
		M.send(cell.lang, cell.text)
	end
end

return M
