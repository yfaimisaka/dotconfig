---------------------------------------------------
--- local lsp client config (keymaps and so on) ---
---------------------------------------------------
local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
    error("Load [cmp_nvim_lsp] Failed!")
    return
end

--- ??? ---
-- used to enable autocompletion (assign to every lsp server config)
M.capabilities = cmp_nvim_lsp.default_capabilities()


M.setup = function()
    -- Change the Diagnostic symbols in the sign column (gutter)
    local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "ﴞ ",},
		{ name = "DiagnosticSignInfo", text = "" },
	}

    -- use iparis to ensure the order is right
	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

    --- ??? ---
    local config = {
        virtual_text = false, -- disable virtual text
        signs = {
            active = signs, -- show signs
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }
	vim.diagnostic.config(config)

    --- ??? ---
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})
	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap
    
    -- set keybinds
    keymap(bufnr, "n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)                       -- show definition, references
    keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)            -- got to declaration
    keymap(bufnr, "n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)                  -- see definition and make edits in window
    keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)         -- go to implementation
    keymap(bufnr, "n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)              -- see available code actions
    keymap(bufnr, "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)                   -- smart rename
    keymap(bufnr, "n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)     -- show  diagnostics for line
    keymap(bufnr, "n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)   -- show diagnostics for cursor
    keymap(bufnr, "n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)             -- jump to previous diagnostic in buffer
    keymap(bufnr, "n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)             -- jump to next diagnostic in buffer
    keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)                         -- show documentation for what is under cursor
    keymap(bufnr, "n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)                   -- see outline on right hand side
end

M.on_attach = function(client, bufnr)
    --- ??? ---
   	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end
	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
	end

    lsp_keymaps(bufnr)

    local status_ok, illuminate = pcall(require, "illuminate")
    if not status_ok then
        error("Load [illuminate] Failed")
        return
    end
    illuminate.on_attach(client)
end

return M
