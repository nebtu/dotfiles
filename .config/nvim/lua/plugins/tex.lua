return {
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_view_method = "zathura"
		end,
	},
	{
		"SirVer/ultisnips",
		init = function()
			vim.g.UltiSnipsExpandTrigger = "<tab>"
			vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
			vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
			vim.g.UltiSnipsUsePythonVersion = 3
			vim.g.UltiSnipsSnippetsDir = "~/.vim/UltiSnips"
			vim.g.UltiSnipsSnippetDirectories = { "~/.vim/UltiSnips" }
			vim.g.UltiSnipsEditSplit = "context"
		end,
	},
}
