local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer() -- true if you not installed packer, and ensure_packer will install for you,
                                         -- false if you already installed packer before

-- Autocommand that reload neovim whenever you save this file
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
    augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then 
    return
end

return packer.startup(function(use)
    use("wbthomason/packer.nvim") 
    
    -- preferred colorscheme
    use("bluz71/vim-nightfly-guicolors") 
    use("lunarvim/darkplus.nvim")

    -- use this to navigate between both vim and tmux
    use("christoomey/vim-tmux-navigator")

    -- maximizes and restore current window
    use("szw/vim-maximizer")

    -- add, change and delete the symbols surrounding string
    -- such as `somestring`, use `ysw` to make it be `"somestring"`
    -- , use `cs"'` to change " to '
    use("tpope/vim-surround")

    -- easily replace something with something yanked in registers
    use("inkarkat/vim-ReplaceWithRegister") -- replace with register contents using motion (gr + motion)

    -- comment 
    use("numToStr/Comment.nvim")

    -- Speed up loading Lua modules 
    use("lewis6991/impatient.nvim")

    -- statusline
    use("nvim-lualine/lualine.nvim")

    -- file explorer
    use {
  'nvim-tree/nvim-tree.lua',
      requires = {
          'nvim-tree/nvim-web-devicons', -- optional, for file icons
      },
      tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    -- autocompletion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")

    -- snippets
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    use("rafamadriz/friendly-snippets")

    -- managing & installing lsp servers, linters & formatters
    use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
    use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig
  
    -- configuring lsp servers
    use("neovim/nvim-lspconfig") -- easily configure language servers
    use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
    use({
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            require('lspsaga').setup({
              -- keybinds for navigation in lspsaga window
              move_in_saga = { prev = "<C-k>", next = "<C-j>" },
              -- use enter to open file with finder
              finder_action_keys = {
                open = "<CR>",
              },
              -- use enter to open file with definition preview
              definition_action_keys = {
                edit = "<CR>",
              },
        })
        end
    }) -- enhanced lsp uis

    use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

    -- syntax highlighting
    use("nvim-treesitter/nvim-treesitter")

    -- auto closing
    use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
    use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

    -- git integration
    use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

    -- automatically highlighting other uses of the word under the cursor
    use("RRethy/vim-illuminate")

    -- markdown preview
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })


    if packer_bootstrap then
        require("packer").sync()
    end
end)
