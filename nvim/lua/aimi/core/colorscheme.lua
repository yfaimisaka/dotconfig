local colorscheme = "darkplus"
-- local colorscheme = "nightfly"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    error("Load colorscheme:" .. "[" .. colorscheme .. "]" .. "Failed!")
    return
end
