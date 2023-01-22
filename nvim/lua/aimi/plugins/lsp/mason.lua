--------------------------------------------------------
--- get lsp servers and use lspconfig to config them ---
--------------------------------------------------------
-- set servers to be install
-- name referrence is here 
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
local servers = {
    "sumneko_lua",
    "gopls",
    "rust_analyzer",
    "pyright",
    "jdtls",
    "tsserver",
    "bashls",
    "jsonls",
    "yamlls",
    "rnix",
}

-- settings for mason
local settings = {
    ui = {
        border = "none",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

-- mason
local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
    error("Load [mason] Failed!")
    return
end

-- mason-lspconfig
local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
    error("Load [mason-lspconfig] Failed!")
    return
end

mason.setup(settings)
mason_lspconfig.setup({
    ensure_installed = servers,
    automatic_installation = true,
})

-- lspconfig
local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local opts = {}

-- set opts for lspconfig.setup
for _, server in pairs(servers) do
    -- same opts for each lsp server
    opts = {
        on_attach = require("aimi.plugins.lsp.handlers").on_attach,
        capabilities = require("aimi.plugins.lsp.handlers").capabilities,
    }

    --- ??? ---
    -- sep=@
    server = vim.split(server, "@")[1]

    -- require custom settings for single lsp
    local require_ok, conf_opts = pcall(require, "aimi.plugins.lsp.settings." .. server)
    if require_ok then
        --- ??? ---
        -- nesting table forcely
        opts = vim.tbl_deep_extend("force", conf_opts, opts)
    end

    lspconfig[server].setup(opts)
end
