--- @class Version
--- @field version string Version number.
--- @field date string Date of the version.
--- @field desc string Description of the version.

--- @class ChangelogPanel
local changelog_panel = {}

--- Creates the changelog GUI.
--- @param player LuaPlayer
--- @param versions Version[]
--- @return nil 
changelog_panel.create = function (player, versions)
    changelog_panel.data = {
        name = 'Changelog',
        versions = versions
    }
end

--- Draws the changelog GUI.
--- @param panel_frame LuaGuiElement The frame to draw the changelog GUI in.
--- @param player LuaPlayer
--- @return nil
changelog_panel.draw = function (panel_frame, player)
    local scroll = panel_frame.add({
        type = 'scroll-pane',
        name = 'scroll_changelog',
        direction = 'vertical',
        horizontal_scroll_policy = 'never',
        vertical_scroll_policy = 'auto'
    })

    for i = 1, #changelog_panel.data.versions do
        local v = changelog_panel.data.versions[i]

        local l = scroll.add({
            type = 'label',
            caption = 'Version ' .. v.version .. ' -- ' .. v.date 
        })
        l.style.font = 'heading-1'
        l.style.font_color = { r = 0.5, g = 0.3, b = 0.1 }
        l.style.minimal_width = 780
        l.style.horizontal_align = 'center'
        l.style.vertical_align = 'center'

        local c = scroll.add({
            type = 'label',
            caption = v.desc
        })
        c.style.font = 'heading-2'
        c.style.single_line = false
        c.style.font_color = { r = 0.85, g = 0.85, b = 0.88 }
        c.style.minimal_width = 780
        c.style.horizontal_align = 'left'
        c.style.vertical_align = 'center'

        local line_v = scroll.add({
            type = 'line'
        })
        line_v.style.top_margin = 4
        line_v.style.bottom_margin = 4
    end
end

return changelog_panel
