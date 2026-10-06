-- ============================================================
-- oil.lua — file explorer as a buffer
-- Edit the filesystem like a normal Neovim buffer
-- ============================================================

return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			columns = { "icon", "permissions", "size", "mtime" },
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["<C-s>"] = "actions.select_vsplit",
				["<leader>cd"] = { "actions.cd", opts = { scope = "win" } },
				-- <C-h> removed: conflicts with vim-tmux-navigator navigate-left
				-- use <C-s> for vsplit, <CR> for current window
				["<C-p>"] = "actions.preview",
				["-"] = "actions.parent",
				["_"] = "actions.open_cwd",
				["gs"] = "actions.change_sort",
				["gx"] = "actions.open_external",
				["g."] = "actions.toggle_hidden",
				["gy"] = "actions.copy_entry_path",
			},
			view_options = { show_hidden = false },
			float = {
				padding = 2,
				max_width = 90,
				max_height = 0,
				border = "rounded",
			},
		})
	end,
}
