return {
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/Documents/org",
				org_default_notes_file = "~/Documents/org/20200909144154-scratchpad.org",
			})
		end,
	},
	{
		"chipsenkbeil/org-roam.nvim",
		dependencies = { "nvim-orgmode/orgmode" },
		config = function()
			require("org-roam").setup({
				directory = "~/Documents/org/",
			})
		end,
	},
}
