local rooms1x1 = require("core.variants.1x1")
local rooms1x2 = require("core.variants.1x2")
local rooms1x3 = require("core.variants.1x3")
local rooms2x2 = require("core.variants.2x2")
local rooms2x3 = require("core.variants.2x3")
local rooms3x3 = require("core.variants.3x3")
local variant_dungeon = require("core.variants.dungeon")

---@class DispatcherVariant
---@field name string Name of a variant.
---@field variant any Variant to use.
---@field weight number Weight of the variant. Increasing the weight will increase the chance of the variant being used.
---@field min_discovered_rooms number Minimum number of discovered variants required for the variant to be available.
---@field max_discovered_rooms number Maximum number of discovered variants allowed for the variant to be available.
---@field guaranteed_at table Levels at which the variant is guaranteed to be used.

--- Info: Each room variation (1x1, 1x2, 1x3, etc.) MUST implement methods: init, init_cell, can_expand, get_random_expandable_positions

---@class Dispatcher
---@field variants DispatcherVariant[] Table of variants.
local dispatcher = {}


--- Initialize the variant dispatcher, initialaze all variants
--- @return nil
dispatcher.init = function ()
    rooms1x1.init()
    rooms1x2.init()
    rooms1x3.init()
    rooms2x2.init()
    rooms2x3.init()
    rooms3x3.init()
    variant_dungeon.init()

    -- TODO make it more random i guess (guaranteed_at and dungeon_at is a bit weird)
    -- name - name of the variant
    -- variant - variant to use, MUST implement methods: init, init_cell, can_expand, get_random_expandable_positions
    -- weight - increasing the weight will increase the chance of the variant being used
    -- min discovered rooms - minimum number of TOTAL discovered variants required for the variant to be available
    -- max discovered rooms - maximum number of TOTAL discovered variants allowed for the variant to be available or 0 for unlimited
    -- guaranteed at - levels at which the variant is guaranteed to be used (if it can be placed at that position in given direction)
    dispatcher.variants = {
        { name = '1x1', variant = rooms1x1, weight = 36, min_discovered_rooms = 0, max_discovered_rooms = 0, guaranteed_at = { 1 } },
        { name = '1x2', variant = rooms1x2, weight = 18, min_discovered_rooms = 12, max_discovered_rooms = 0, guaranteed_at = { 5 } },
        { name = '1x3', variant = rooms1x3, weight = 9, min_discovered_rooms = 18, max_discovered_rooms = 0, guaranteed_at = { 10 } },
        { name = '2x2', variant = rooms2x2, weight = 5, min_discovered_rooms = 24, max_discovered_rooms = 0, guaranteed_at = { 25 } },
        { name = '2x3', variant = rooms2x3, weight = 3, min_discovered_rooms = 33, max_discovered_rooms = 0, guaranteed_at = { 34 } },
        { name = '3x3', variant = rooms3x3, weight = 2, min_discovered_rooms = 45, max_discovered_rooms = 0, guaranteed_at = { 46 } },
        { name = 'dungeon', variant = variant_dungeon, weight = 3, min_discovered_rooms = 50, max_discovered_rooms = 0, guaranteed_at = { 51 } },
    }

    for _, variant in pairs(dispatcher.variants) do
        global.variants[variant.name] = global.variants[variant.name] or { discovered_rooms = 1 }
    end
end

--- Place a random variant in the given direction on a given position
--- @param surface LuaSurface - Surface on which the variant will be placed
--- @param position table - Position on which the variant will be placed
--- @param direction defines.direction - Direction in which the variant will be placed
--- @return nil
dispatcher.place_random_variant = function (surface, position, direction)
    local variant = dispatcher.select_random_variant(position, direction)
    local variant_positions = variant.variant.get_random_expandable_positions(position, direction)

    dispatcher.select_random_room(variant)(surface, variant_positions)

    global.variants[variant.name].discovered_rooms = global.variants[variant.name].discovered_rooms + 1

    variant.variant.init_cell(variant_positions)

    for _, variant_position in pairs(variant_positions) do
        dispatcher.regenerate_decoratives_on_chunk(surface, variant_position)
    end

    global.discovered_rooms = global.discovered_rooms + 1
end

--- Select a random variant based on weight and internal variant data
--- @param position table - Position on which the variant will be placed
--- @param direction defines.direction - Direction in which the variant will be placed
--- @return DispatcherVariant
dispatcher.select_random_variant = function (position, direction)
    local total_weight = 0
    
    local active_variants = {} ---@type DispatcherVariant[]
    local valid_variants = {} ---@type DispatcherVariant[]
    
    for _, variant in pairs(dispatcher.variants) do
        if 
            global.discovered_rooms >= variant.min_discovered_rooms and
            (
                variant.max_discovered_rooms == 0 or 
                global.variants[variant.name].discovered_rooms <= variant.max_discovered_rooms
            ) and
            variant.variant.can_expand(position, direction)
        then
            table.insert(active_variants, variant)
        end
    end

    for _, variant in pairs(active_variants) do
        for i = 1, variant.weight do
            total_weight = total_weight + 1
            valid_variants[total_weight] = variant
        end
    end

    local random_value = math.random(0, total_weight) + 1

    return valid_variants[random_value] or dispatcher.variants[1]
end

--- Selects a random room from a table of rooms based on their weights.
--- @param variant DispatcherVariant from which room comes
--- @return Room
dispatcher.select_random_room = function (variant)
    local total_weight = 0
    local discovered_rooms = global.variants[variant.name].discovered_rooms
    local valid_rooms = {}

    for _, room_info in pairs(variant.variant.rooms) do
        if 
            discovered_rooms >= room_info.min_discovered_rooms and
            (
                room_info.max_discovered_rooms == 0 or 
                global.variants[variant.name].discovered_rooms <= room_info.max_discovered_rooms
            )
        then
            for i = 1, room_info.weight do
                total_weight = total_weight + 1
                valid_rooms[total_weight] = room_info.func
            end
        end
    end

    -- Check if any rooms are guaranteed to spawn at certain points
    for _, room_info in pairs(variant.variant.rooms) do
        if #room_info.guaranteed_at > 0 then
            for _, guaranteed_point in ipairs(room_info.guaranteed_at) do
                if global.variants[variant.name].discovered_rooms == guaranteed_point then
                    return room_info.func
                end
            end
        end
    end

    -- Randomly choose a valid room
    local random_value = math.random(1, total_weight)

    return valid_rooms[random_value]
end

dispatcher.regenerate_decoratives_on_chunk = function (surface, position)
    surface.destroy_decoratives({ area = { { position.x * 32, position.y * 32 }, { position.x * 32 + 32, position.y * 32 + 32 } } })

    local decorative_names = {}

    for k, v in pairs(game.decorative_prototypes) do
        if v.autoplace_specification then
            decorative_names[#decorative_names + 1] = k
        end
    end

    surface.regenerate_decorative(decorative_names, { position })
end

return dispatcher