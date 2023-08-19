--- @class PlayerPanel
local player_panel = {}

--- Creates the player GUI.
--- @param player LuaPlayer
--- @return nil
player_panel.create = function (player)
    player_panel.data = {
        name = 'Player'
    }
end

--- Draws the player GUI.
--- @param panel_frame LuaGuiElement The frame to draw the player GUI in.
--- @param player LuaPlayer
--- @return nil
player_panel.draw = function (panel_frame, player)
    local scroll = panel_frame.add({
        type = 'scroll-pane',
        name = 'scroll_player',
        direction = 'vertical',
        horizontal_scroll_policy = 'never',
        vertical_scroll_policy = 'auto'
    })

    local l = scroll.add({
        type = 'label',
        caption = 'Player'
    })
    l.style.font = 'heading-1'
    l.style.font_color = { r = 0.2, g = 0.9, b = 0.2 }
    l.style.minimal_width = 780
    l.style.horizontal_align = 'center'
    l.style.vertical_align = 'center'
end

return player_panel