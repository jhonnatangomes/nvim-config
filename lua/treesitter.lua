local status_ok, treesitter_config = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

treesitter_config.setup({
	ensure_installed = { "javascript", "typescript" },
	autotag = {
		enable = true,
	},
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = true,
		disable = function(lang, buf)
			local max_filesize = 200 * 1024 -- 200Kb
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
	indent = {
		enable = true,
	},
	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
})
