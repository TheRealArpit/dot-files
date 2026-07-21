-- =============================================================
-- ~/.hammerspoon/init.lua — focus management only
-- Ctrl+Opt+[ / ] — move keyboard focus to prev/next monitor
-- Does NOT move any window. Just shifts focus so keypresses
-- and clicks land on the other screen.
-- =============================================================

local function focusMonitor(screen)
  -- Find the frontmost window on the target screen and focus it.
  -- If there are no windows there, just warp the mouse so the
  -- screen becomes active for clicks.
  local wins = hs.window.orderedWindows()
  for _, win in ipairs(wins) do
    if win:screen() == screen and win:isStandard() then
      win:focus()
      return
    end
  end
  -- No window on that screen — move mouse to its centre so it becomes active
  local centre = hs.geometry.rectMidPoint(screen:fullFrame())
  hs.mouse.absolutePosition(centre)
end

-- use the focused window's screen as reference, not the menu bar screen
local function currentScreen()
  local win = hs.window.focusedWindow()
  if win then return win:screen() end
  return hs.screen.mainScreen()
end

hs.hotkey.bind({'ctrl', 'alt'}, ']', function()
  focusMonitor(currentScreen():next())
end)

hs.hotkey.bind({'ctrl', 'alt'}, '[', function()
  focusMonitor(currentScreen():previous())
end)
