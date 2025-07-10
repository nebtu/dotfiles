return {
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/Nextcloud/Documents/org/*",
				org_default_notes_file = "~/Nextcloud/Documents/org/scratchpad.org",
			})
		end,
	},
	{
		"chipsenkbeil/org-roam.nvim",
		dependencies = { "nvim-orgmode/orgmode" },
		config = function()
			require("org-roam").setup({
				directory = "~/Nextcloud/Documents/org/",
			})
		end,
	},
}
