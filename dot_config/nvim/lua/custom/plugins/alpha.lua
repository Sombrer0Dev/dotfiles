return {
  "goolord/alpha-nvim",
  requires = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Set header
    dashboard.section.header.val = {
      [[=================     ===============     ===============   ========  ========]],
      [[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
      [[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
      [[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
      [[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
      [[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
      [[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
      [[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
      [[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
      [[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
      [[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
      [[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
      [[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
      [[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
      [[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
      [[||.=='    _-'                                                     `' |  /==.||]],
      [[=='    _-'                        [ Z I N A ]                         \/   `==]],
      [[\   _-'                                                                `-_   /]],
      [[ `''                                                                      ``' ]],
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
      dashboard.button("p", "  > Projects", ":lua require'telescope'.extensions.projects.projects()<CR>"),
      dashboard.button("w", "  > Find repos",
        ":cd $HOME/Workspace | lua require'telescope'.extensions.repo.list{search_dirs = {'~/Workspace'}} <cr>"),
      dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | wincmd k | pwd<CR> | <cmd> Neotree toggle<cr>"),
      dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
    }

    -- Set footer
    --   NOTE: This is currently a feature in my fork of alpha-nvim (opened PR #21, will update snippet if added to main)
    --   To see test this yourself, add the function as a dependecy in packer and uncomment the footer lines
    --   ```init.lua
    --   return require('packer').startup(function()
    --       use 'wbthomason/packer.nvim'
    --       use {
    --           'goolord/alpha-nvim', branch = 'feature/startify-fortune',
    --           requires = {'BlakeJC94/alpha-nvim-fortune'},
    --           config = function() require("config.alpha") end
    --       }
    --   end)
    --   ```
    -- local fortune = require("alpha.fortune")
    -- dashboard.section.footer.val = fortune()

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
    ]])
  end
}
