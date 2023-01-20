local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    error("Load [lspconfig] Failed!")
    return
end

require("aimi.plugins.lsp.mason")
require("aimi.plugins.lsp.handlers").setup()

