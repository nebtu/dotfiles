return {
	{
		"nvim-orgmode/orgmode",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-orgmode/telescope-orgmode.nvim",
			"nvim-orgmode/org-bullets.nvim",
			"Saghen/blink.cmp",
		},
		event = "VeryLazy",
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/Nextcloud/Documents/org/*",
				org_default_notes_file = "~/Nextcloud/Documents/org/scratchpad.org",
				org_id_link_to_org_use_id = true,
			})
			require("org-bullets").setup()
			require("telescope").load_extension("orgmode")
			vim.keymap.set("n", "<leader>so", require("telescope").extensions.orgmode.search_headings)
			vim.keymap.set("n", "<leader>olt", require("telescope").extensions.orgmode.insert_link)
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
