local M = {}

M.setup = function(user_config)
	require("void.colors").extend(user_config or {})
end

M.load = function(user_config)
	local config = require("void.colors").config
	if user_config then
		vim.tbl_deep_extend("force", config, user_config)
	end

	-- we only need to run this if another theme is already set
	-- otherwise, assume it's a clean slate
	if vim.g.colors_name then
		vim.cmd("highlight clear")
	end

	vim.g.colors_name = "void"
	vim.o.termguicolors = true

	-- for colorscheme
	require("void.colors").setup(config)
	-- for config
	require("void.config").setup(config)
end

return M
