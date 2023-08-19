local mod_info_panel = require('core.gui.panels.mod_info')
local changelog_panel = require('core.gui.panels.changelog')
local player_panel = require('core.gui.panels.player')
local stats_panel = require('core.gui.panels.stats')
local C = require('core.utils.constants')

--- @class Gui
local gui = {}

--- Creates the GUI.
--- @param player LuaPlayer
--- @return LuaGuiElement, LuaGuiElement The main frame and the inside table.
gui.create = function(player)
    if player.gui.top['caver_miner_stats_toggle_button'] then
        player.gui.top['caver_miner_stats_toggle_button'].destroy()
    end

    if player.gui.top['caver_miner_stats_frame'] then
        player.gui.top['caver_miner_stats_frame'].destroy()
    end

    if (player.gui.screen['world_miner_gui']) then
        player.gui.screen['world_miner_gui'].destroy()
    end

    if player.gui.top['gui_toggle_button'] then
        player.gui.top['gui_toggle_button'].destroy()
    end

    local b = player.gui.top.add({type = 'sprite-button', name = 'gui_toggle_button', sprite = 'item/dummy-steel-axe'})
    
    b.style.minimal_height = 48
    b.style.minimal_width = 48
    b.style.padding = 1

    local gui_frame = player.gui.screen.add({
        type = 'frame',
        name = 'world_miner_gui',
        direction = 'vertical'
    })
    gui_frame.location = { 0, 48 }

    local titlebar = gui_frame.add({
        type = 'flow',
        name = 'titlebar',
        direction = 'horizontal'
    })
    titlebar.style.horizontal_spacing = 8
    titlebar.style = 'horizontal_flow'
    titlebar.drag_target = gui_frame
    titlebar.add({
        type = 'label',
        name = 'main_label',
        style = 'frame_title',
        caption = 'World Miner',
        ignored_by_interaction = true
    })

    local widget = titlebar.add({
        type = 'empty-widget',
        style = 'draggable_space',
        ignored_by_interaction = true
    })
    widget.style.left_margin = 4
    widget.style.right_margin = 4
    widget.style.height = 20
    widget.style.horizontally_stretchable = true

    titlebar.add({
        type = 'sprite-button',
        name = 'close_gui_button',
        style = 'frame_action_button',
        mouse_button_filter = {'left'},
        sprite = 'utility/close_white',
        hovered_sprite = 'utility/close_black',
        clicked_sprite = 'utility/close_black',
        tooltip = 'Close',
    })

    local inside_frame = gui_frame.add({
        type = 'frame',
        style = 'inside_shallow_frame'
    })

    local inside_frame_style = inside_frame.style
    inside_frame_style.vertically_stretchable = true
    inside_frame_style.maximal_height = 800

    local inside_table = inside_frame.add({
        type = 'table',
        column_count = 1,
        name = 'inside_frame'
    })
    inside_table.style.padding = 3

    gui.panels = {}
    
    table.insert(gui.panels, mod_info_panel)
    table.insert(gui.panels, changelog_panel)
    -- table.insert(gui.panels, player_panel)
    table.insert(gui.panels, stats_panel)
    
    mod_info_panel.create(player)
    changelog_panel.create(player, C.changelog)
    -- player_panel.create(player)
    stats_panel.create(player)

    return gui_frame, inside_table
end

--- Draws the GUI.
--- @param player LuaPlayer
--- @return nil
gui.draw = function(player)
    local frame, inside_frame = gui.create(player)

    local tabbed_pane = inside_frame.add({
        type = 'tabbed-pane',
        name = 'tabbed_pane'
    })

    for index, panel in pairs(gui.panels) do
        local panel_frame = tabbed_pane.add({
            type = 'frame',
            name = panel.data.name,
            direction = 'vertical'
        })
        panel_frame.style.minimal_height = 480
        panel_frame.style.maximal_height = 480
        panel_frame.style.minimal_width = 800
        panel_frame.style.maximal_width = 800

        local tab = tabbed_pane.add({
            type = 'tab',
            caption = panel.data.name,
            name = index
        })
        tabbed_pane.add_tab(tab, panel_frame)

        panel.draw(panel_frame, player)
    end

    tabbed_pane.selected_tab_index = 1
end

--- Refreshes the GUI.
--- @return nil
gui.refresh = function()
    for _, player in pairs(game.connected_players) do
        gui.draw(player)
    end
end

--- Handles the GUI click event.
--- @param event table
--- @return nil
gui.on_click = function(event)
    if not event then return end
    if not event.element then return end
    if not event.element.valid then return end

    local player = game.players[event.element.player_index]

    if event.element.name == 'close_gui_button' then
        player.gui.screen['world_miner_gui'].destroy()
    elseif event.element.name == 'gui_toggle_button' then
        if player.gui.screen['world_miner_gui'] then
            player.gui.screen['world_miner_gui'].destroy()
        else
            gui.draw(player)
        end
    end
end

return gui
