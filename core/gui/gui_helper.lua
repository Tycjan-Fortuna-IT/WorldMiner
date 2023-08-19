--- @class GuiHelper
local gui_helper = {}

--- Adds a label to the parent element.
--- @param parent LuaGuiElement The parent element.
--- @param caption string The caption of the label.
--- @param style table The style of the label.
--- @return nil
gui_helper.add_label = function (parent, caption, style)
    local label = parent.add({
        type = 'label',
        caption = caption
    })

    label.style.font = style.font or 'heading-2'
    label.style.single_line = style.single_line or false
    label.style.font_color = style.font_color or { r = 0.85, g = 0.85, b = 0.88 }
    label.style.minimal_width = style.minimal_width or 780
    label.style.horizontal_align = style.horizontal_align or 'center'
    label.style.vertical_align = style.vertical_align or 'center'

    return gui_helper
end

--- Adds a line to the parent element.
--- @param parent LuaGuiElement The parent element.
--- @param style table The style of the line.
--- @return nil
gui_helper.add_line = function (parent, style)
    local line = parent.add({
        type = 'line'
    })

    line.style.top_margin = style.top_margin or 4
    line.style.bottom_margin = style.bottom_margin or 4

    return gui_helper
end

return gui_helper
