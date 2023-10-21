local w = require('wezterm')
local action = w.action

local workspace_switcher = require("workspace_switcher.workspace_switcher")

local function is_nvim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
  Left = 'h',
  Down = 'j',
  Up = 'k',
  Right = 'l',
  -- reverse lookup
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'CTRL|ALT' or 'CTRL',
    action = w.action_callback(function(win, pane)
      if is_nvim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'CTRL|ALT' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

local function split_screen(direction, key)
  return {
    key = key,
    mods = "ALT",
    action = w.action_callback(function(win, pane)
      if is_nvim(pane) then
        win:perform_action({ SplitPane = { direction = direction, size = { Percent = 20 } } }, pane)
      else
        win:perform_action({ SplitPane = { direction = direction, size = { Percent = 50 } } }, pane)
      end
    end)
  }
end

return {
  split_screen("Right", "/"),
  split_screen("Down", "'"),
  { key = "z", mods = "ALT", action = "TogglePaneZoomState" },
  { key = "d", mods = "ALT", action = action({ CloseCurrentPane = { confirm = false } }) },

  -- Pane Navigates

  -- Pane Cycles
  { key = "[", mods = "ALT", action = action({ ActivatePaneDirection = "Prev" }) },
  { key = "]", mods = "ALT", action = action({ ActivatePaneDirection = "Next" }) },


  -- TAB Section
  -- Rename TAB
  {
    key = 'R',
    mods = 'CTRL|SHIFT',
    action = action.PromptInputLine {
      description = 'Enter new name for tab',
      action = w.action_callback(function(window, _, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  -- TAB Creation
  { key = 'c', mods = 'CTRL|ALT', action = action.SpawnTab 'CurrentPaneDomain' },

  -- TAB Navigation
  { key = "n", mods = "ALT",      action = action({ ActivateTabRelative = 1 }) },
  { key = "m", mods = "ALT",      action = action({ ActivateTabRelative = -1 }) },
  { key = "t", mods = "ALT|CTRL", action = action.ShowTabNavigator },

  -- Fullscreen
  { key = "f", mods = "ALT|CTRL", action = "ToggleFullScreen" },
  { key = "n", mods = "ALT|CTRL", action = "SpawnWindow" },

  -- Workspaces

  { key = 'w', mods = 'ALT|CTRL', action = action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES|DOMAINS" } },
  {
    key = "s",
    mods = "ALT",
    action = workspace_switcher.workspace_switcher(function(label)
      return w.format({
        { Text = "󱂬: " .. label },
      })
    end),
  },



  -- Move Between Panes With Navigator.nvim
  -- move between split panes
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- resize panes
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),
  { key = 'c', mods = 'CTRL|SHIFT', action = action { CopyTo = 'ClipboardAndPrimarySelection' } },
}
