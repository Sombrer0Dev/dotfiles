local M = {}

local utils = require("utils.functions")
local plugins = vim.g.config.plugins
local tex = vim.g.config.plugins.tex

local health = vim.health
local _ok = health.ok
local _warn = health.warn
local _error = health.error

local programs = {
  go = {
    required = false,
    desc = "some Go related features might not work",
  },
  node = {
    required = false,
    desc = "Mason will not be able to install some LSPs/tools",
  },
  cargo = {
    required = false,
    desc = "some Rust related features might not work and tools that are built by cargo cannot be installed",
  },
  trash = {
    required = true,
    desc = "Neo-tree requires 'trash-cli' to be able to move files to the trash",
  },
  rg = {
    required = true,
    desc = "a highly recommended grep alternative (ripgrep is the package name)",
  },
  fd = {
    required = true,
    desc = "a highly recommended find alternative",
  },
  fzf = {
    required = true,
    desc = "a highly recommended fuzzy finder (nvim-bqf dependency)",
  },
}

local exec_not_found_template = "'%s' executable not found - %s"
local exec_found_template = "'%s' executable found"

M.check = function()
  vim.health.start("System configuration")

  if not utils.isNeovimVersionsatisfied(10) then
    _warn("This config probably won't work very well with Neovim < 0.10")
  else
    _ok("This config will work with your Neovim version")
  end

  for k, v in pairs(programs) do
    if not utils.isExecutableAvailable(k) then
      if v.required then
        _error(string.format(exec_not_found_template, k, v.desc))
      else
        _warn(string.format(exec_not_found_template, k, v.desc))
      end
    else
      _ok(string.format(exec_found_template, k))
    end
  end

  if not utils.isExecutableAvailable("python") then
    if not utils.isExecutableAvailable("python3") then
      _warn("Python was not found - some Python related features might not work")
    end
  end

  if plugins.telescope.fzf_native.enable then
    if
      not (utils.isExecutableAvailable("cmake") or utils.isExecutableAvailable("make"))
      or not (utils.isExecutableAvailable("gcc") or utils.isExecutableAvailable("clang"))
    then
      _warn(
        "Make sure your platform meets the requirements for building telescope-fzf-native: https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation"
      )
    end
  end
end

return M
