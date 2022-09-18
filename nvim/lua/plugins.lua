require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    -- Catppuccin color scheme
    use {
        "catppuccin/nvim",
        as = "catppuccin",
        run = ":CatppuccinCompile",
    }

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }

    -- edit surrounding characters
    use "kylechui/nvim-surround"

    -- better commenting
    use {
        "numToStr/comment.nvim",
        tag = "*",
    }

    -- LSP using nvim-cmp
    use "neovim/nvim-lspconfig"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"

    -- LuaSnip and nvim-cmp source
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"

    -- snippets
    use "rafamadriz/friendly-snippets"

    -- pretty symbols
    use "onsails/lspkind.nvim"
    use "kyazdani42/nvim-web-devicons"

    -- mason to manage installs
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"

    -- auto formatting
    use "mhartington/formatter.nvim"

    -- file explorer
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    }
end)

-- Catppuccin color scheme setup
require("catppuccin").setup {
    compile = {
        enabled = true,
        path = vim.fn.stdpath "cache" .. "/catppuccin",
    },
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = { "italic" },
        keywords = { "italic" },
    },
    integrations = {
        cmp = true,
        treesitter = true,
        native_lsp = {
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
        },
    },
}

vim.cmd [[colorscheme catppuccin]]

-- Treesitter setup
require("nvim-treesitter.configs").setup {
    -- list of parsers to install
    ensure_installed = { "lua", "python" },
    auto_install = true,
    -- enable highlighting
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

require("nvim-surround").setup()
require("Comment").setup()

-- completion setup
local cmp = require "cmp"
local lspkind = require "lspkind"
local luasnip = require "luasnip"

cmp.setup {
    -- formatting
    formatting = {
        format = lspkind.cmp_format {
            with_text = true,
            menu = {
                luasnip = "[snip]",
                nvim_lua = "[api]",
                nvim_lsp = "[LSP]",
                buffer = "[buf]",
                path = "[path]",
                cmdline = "[cmd]",
            },
        },
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
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            { "i", "c" }
        ),
        ["<C-k>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-j>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    -- list of sources in order of priority
    sources = {
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "buffer" },
    },
    -- luasnip support
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
}

-- use buffer source for '/'
cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})

-- use cmdline and path source for ':'
cmp.setup.cmdline(":", {
    sources = cmp.config.sources {
        { name = "path" },
        { name = "cmdline" },
    },
})

-- LuaSnip and snippets setup
require("luasnip.loaders.from_vscode").lazy_load()

luasnip.config.set_config {
    store_selection_keys = "<C-s>",
}

-- mason setup
require("mason").setup {
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    },
    log_level = vim.log.levels.INFO,
}
require("mason-lspconfig").setup {
    ensure_installed = { "sumneko_lua", "pyright", "texlab" },
    auto_install = true,
}
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
vim.diagnostic.config {
    virtual_text = false,
    severity_sort = true,
}

local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = "",
    })
end

sign { name = "DiagnosticSignError", text = "" }
sign { name = "DiagnosticSignWarn", text = "" }
sign { name = "DiagnosticSignHint", text = "" }
sign { name = "DiagnosticSignInfo", text = "" }

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
    return require("lspconfig")[server].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            Lua = {
                diagnostics = { globals = { "vim", "bufnr" } },
            },
        },
    }
end

setup "sumneko_lua"
setup "pyright"
setup "texlab"
-- lspconfig.pyright.setup{
-- capabilities = capabilities
-- }

-- formatter setup
require("formatter").setup {
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
}

require("neo-tree").setup {
    filesystem = {
        filtered_items = {
            hide_dotfiles = false,
        },
        hijack_netrw_behaviour = "open_current",
        use_libuv_file_watcher = true,
    },
}
