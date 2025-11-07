-- plugins/telescope.lua:
return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim' },

	defaults = {
		preview = {
			-- Set to your desired limit, e.g., 10MB
			-- Default is 25MB, but you can decrease it if you have very large files
			filesize_limit = 1000 * 1024 * 1024, -- 10MB in bytes
			-- Other configuration options...
		},
		-- other default configurations...
	},

}
