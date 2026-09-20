local ra_settings = {
	cargo = {
		target = "xtensa-esp32s3-none-elf",
		allTargets = false,
		extraEnv = {
			RUST_TOOLCHAIN = "esp",
			RUSTUP_TOOLCHAIN = "esp",
		},
	},
}

-- Configure rustaceanvim via vim.g.rustaceanvim
local existing = vim.g.rustaceanvim
vim.g.rustaceanvim = function()
	local base = type(existing) == "function" and existing() or (type(existing) == "table" and existing or {})

	return vim.tbl_deep_extend("force", base, {
		server = {
			cmd = { "rustup", "run", "stable", "rust-analyzer" },
			extra_env = { RUSTUP_TOOLCHAIN = "stable", RUST_TOOLCHAIN = "stable" },
			default_settings = {
				["rust-analyzer"] = ra_settings,
			},
			settings = function(project_root, default_settings)
				local base_settings = type(base.server and base.server.settings) == "function"
						and base.server.settings(project_root, default_settings)
					or (base.server and base.server.settings)
					or default_settings
					or {}
				return vim.tbl_deep_extend("force", base_settings, {
					["rust-analyzer"] = ra_settings,
				})
			end,
		},
	})
end

-- Register in vim.lsp.config for rustaceanvim client configuration
vim.lsp.config("rust-analyzer", {
	cmd = { "rustup", "run", "stable", "rust-analyzer" },
	cmd_env = { RUSTUP_TOOLCHAIN = "stable" },
	settings = {
		["rust-analyzer"] = ra_settings,
	},
})
