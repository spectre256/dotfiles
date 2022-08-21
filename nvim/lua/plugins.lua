require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- Catppuccin color scheme
	use({ "catppuccin/nvim", as = "catppuccin" })

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	-- LSP using nvim-cmp
	use("neovim/nvim-lspconfig")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")

	-- LuaSnip and nvim-cmp source
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")

	-- Pretty symbols
	use("onsails/lspkind.nvim")
	use("kyazdani42/nvim-web-devicons")

	-- mason to manage installs
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	-- auto formatting
	use("mhartington/formatter.nvim")
end)

-- Catppuccin color scheme setup
vim.g.catppuccin_flavour = "macchiato"

require("catppuccin").setup()

vim.cmd([[colorscheme catppuccin]])

-- Treesitter setup
require("nvim-treesitter.configs").setup({
	-- list of parsers to install
	ensure_installed = { "lua", "python" },
	auto_install = true,
	-- enable highlighting
	highlight = {
		enable = true,
	},
})

-- completion setup
local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
	-- formatting
	formatting = {
		format = lspkind.cmp_format({
			with_text = true,
			menu = {
				nvim_lua = "[api]",
				nvim_lsp = "[LSP]",
				luasnip = "[snip]",
				buffer = "[buf]",
				path = "[path]",
				cmdline = "[cmd]",
			},
		}),
	},
	-- keybindings (for insert and command mode)
	mapping = {
		["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
		["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-2), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(2), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
		["<C-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
			{ "i", "c" }
		),
	},
	-- list of sources in order of priority
	sources = {
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
	},
	-- luasnip support
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})

-- use buffer source for '/'
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

-- use cmdline and path source for ':'
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
		{ name = "cmdline" },
	}),
})

-- mason setup
require("mason").setup({
	ui = {
		icons = {
			package_installed = "",
			package_pending = "",
			package_uninstalled = "",
		},
	},
    log_level = vim.log.levels.INFO,
})
require("mason-lspconfig").setup({
	ensure_installed = { "sumneko_lua", "pyright" },
	auto_install = true,
})
-- require("mason-lspconfig").setup()

-- local lspconfig = require('lspconfig')
--
-- local lsp_defaults = {
-- capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
-- on_attach = function(client, bufnr)
-- lspconfig.util.default_config.on_attach(client, bufnr)
-- end,
-- }
--
-- lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)

-- diagnostics setup
vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
})

local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = "",
	})
end

sign({ name = "DiagnosticSignError", text = "" })
sign({ name = "DiagnosticSignWarn", text = "" })
sign({ name = "DiagnosticSignHint", text = "" })
sign({ name = "DiagnosticSignInfo", text = "" })

-- lspconfig setup
local function on_attach()
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	local opts = { noremap = true, silent = true }

	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
local function setup(server)
	return require("lspconfig")[server].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

setup("sumneko_lua")
setup("pyright")
-- lspconfig.pyright.setup{
-- capabilities = capabilities
-- }

-- formatter setup
require("formatter").setup({
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		python = {
			require("formatter.filetypes.python").black,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
