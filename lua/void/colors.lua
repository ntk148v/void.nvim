local M = {}

-- Default configuration
M.config = {
	transparent = false,
	glow = false,
	show_end_of_buffer = true,
	colors = {},
}

if vim.o.background == 'dark' then
	-- dark theme --
	M.config.colors = {
		fg = "#c0c0c0",
		bg = "#1c1c1c",
		cursor = "#bdfe58",
		line_nr = "#404040",
		visual = "#303030",
		comment = "#585858",
		string = "#d1d1d1",
		func = "#e1e1e1",
		kw = "#f1f1f1",
		identifier = "#b1b1b1",
		type = "#a1a1a1",
		type_builtin = "#c5c5c5",
		search_highlight = "#1bfd9c",
		operator = "#1bfd9c",
		bracket = "#e6e6e6",
		preprocessor = "#4b8902",
		bool = "#66b2b2",
		constant = "#b2d8d8",
		glow_color = "#1bfd9c",

		-- enable or disable specific plugin highlights
		plugins = {
			gitsigns = true,
			nvim_cmp = true,
			treesitter = true,
			nvimtree = true,
			telescope = true,
			lualine = true,
			bufferline = true,
			oil = true,
			whichkey = true,
			nvim_notify = true,
		},

		-- gitsigns colors
		added = "#baffc9",
		changed = "#ffffba",
		removed = "#ffb3ba",

		-- Pmenu colors
		pmenu_bg = "#1c1c1c",
		pmenu_sel_bg = "#1bfd9c",
		pmenu_fg = "#c0c0c0",

		-- EndOfBuffer color
		eob = "#3c3c3c",

		-- Telescope specific colors
		border = "#585858",
		title = "#bdfe58",

		-- bufferline specific colors
		bufferline_selection = "#1bfd9c",

		-- LSP diagnostics colors
		error = "#dea6a0",
		warning = "#d6efd8",
		hint = "#bedc74",
		info = "#7fa1c3",
	}
else
	-- light theme --
	M.config.colors = {
		fg = "#1c1c1c",
		bg = "#f1f1f1",
		cursor = "#4b8902",
		line_nr = "#e0e0e0",
		visual = "#c0c0c0",
		comment = "#888888",
		string = "#404040",
		func = "#333333",
		kw = "#000000",
		identifier = "#444444",
		type = "#555555",
		type_builtin = "#c5c5c5",
		search_highlight = "#17b88a",
		operator = "#17b88a",
		bracket = "#888888",
		preprocessor = "#4b8902",
		bool = "#006b6b",
		constant = "#005757",
		glow_color = "#17b88a",

		-- enable or disable specific plugin highlights
		plugins = {
			gitsigns = true,
			nvim_cmp = true,
			treesitter = true,
			nvimtree = true,
			telescope = true,
			lualine = true,
			bufferline = true,
			oil = true,
			whichkey = true,
			nvim_notify = true,
		},

		-- gitsigns colors
		added = "#99d6a0",
		changed = "#e6e59b",
		removed = "#ff8f9e",

		-- Pmenu colors
		pmenu_bg = "#f1f1f1",
		pmenu_sel_bg = "#17b88a",
		pmenu_fg = "#1c1c1c",

		-- EndOfBuffer color
		eob = "#3c3c3c",

		-- Telescope specific colors
		border = "#585858",
		title = "#9bce47",

		-- bufferline specific colors
		bufferline_selection = "#17b88a",

		-- LSP diagnostics colors
		error = "#b66b66",
		warning = "#a3d5c1",
		hint = "#9ebd5c",
		info = "#5a7a9e",
	}
end

M.extend = function(user_config)
	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})
end

-- Apply the colorscheme (using defined colors and groups)
function M.setup(user_config)
	-- Merge user configuration with default (optional)
	M.config = vim.tbl_deep_extend("force", M.config, user_config or {})

	local colors = M.config.colors

	local highlight_groups = {
		Normal = { fg = colors.fg, bg = colors.bg or M.config.transparent and "NONE" },
		Cursor = { fg = colors.cursor, bg = colors.bg or M.config.transparent and "NONE" },
		LineNr = { fg = colors.line_nr },
		Visual = { bg = colors.visual },

		Comment = { fg = colors.comment, gui = "italic" },
		String = { fg = colors.string },
		Function = { fg = colors.func },
		Keyword = { fg = colors.kw },
		Identifier = { fg = colors.identifier },
		Type = { fg = colors.type },
		PreProc = { fg = colors.preprocessor },
		Boolean = { fg = colors.bool },
		Constant = { fg = colors.constant },

		Search = { fg = colors.search_highlight, bg = "NONE", gui = "bold" },
		IncSearch = { fg = colors.search_highlight, bg = "NONE", gui = "bold" },
		Operator = { fg = colors.operator },
		Delimiter = { fg = colors.bracket },

		Pmenu = { fg = colors.pmenu_fg, bg = colors.pmenu_bg or M.config.transparent and "NONE" },
		PmenuSel = { fg = colors.pmenu_bg, bg = colors.pmenu_sel_bg, gui = "bold" },

		-- have to define treesitter based functions as well for glow effect
		["@function"] = { fg = colors.func },
		["@keyword"] = { fg = colors.kw },
		["@identifier"] = { fg = colors.identifier },
		["@operator"] = { fg = colors.operator },

		-- EndOfBuffer
		EndOfBuffer = {
			fg = M.config.show_end_of_buffer and colors.eob or colors.bg,
			bg = colors.bg or M.config.transparent and "NONE",
		},

		-- LSP diagnostics
		DiagnosticError = { fg = colors.error },
		DiagnosticWarn = { fg = colors.warning },
		DiagnosticHint = { fg = colors.hint },
		DiagnosticInfo = { fg = colors.info },
		DiagnosticVirtualTextError = { fg = colors.error },
		DiagnosticVirtualTextWarn = { fg = colors.warning },
		DiagnosticVirtualTextHint = { fg = colors.hint },
		DiagnosticVirtualTextInfo = { fg = colors.info },

		DiagnosticUnderlineError = { gui = "underline", sp = colors.error },
		DiagnosticUnderlineWarn = { gui = "underline", sp = colors.warning },
		DiagnosticUnderlineHint = { gui = "underline", sp = colors.hint },
		DiagnosticUnderlineInfo = { gui = "underline", sp = colors.info },
	}

	local function apply_highlight(group_name, config)
		local cmd = "highlight " .. group_name
		if config.fg then
			cmd = cmd .. " guifg=" .. config.fg
		end
		if config.bg then
			cmd = cmd .. " guibg=" .. config.bg
		end
		if config.gui then
			cmd = cmd .. " gui=" .. config.gui
		end
		if config.sp then
			cmd = cmd .. " guisp=" .. config.sp
		end

		if
			M.config.glow
			and (
				group_name == "Function"
				or group_name == "Keyword"
				or group_name == "Identifier"
				or group_name == "Operator"
				or group_name == "@function"
				or group_name == "@keyword"
				or group_name == "@identifier"
				or group_name == "@operator"
			)
		then
			cmd = cmd .. " gui=bold guisp=" .. colors.glow_color
		end

		vim.cmd(cmd)
	end

	-- Apply all highlights
	for group_name, config in pairs(highlight_groups) do
		apply_highlight(group_name, config)
	end

	-- Apply plugin specific highlight groups
	require("void.config").setup(M.config)
end

return M