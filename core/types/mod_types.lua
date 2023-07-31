-- I love types, but lua doesn't have them. So we have to document our types manually.

--- @class Global
global = {
    --- Used to store player stats.
    --- @type array<PlayerStats>
    player_stats = {},

    --- Used to store the amount of ores mined.
    --- @type MinerTable
    rocks_yield_ore = {},

    --- Defines how rich stone is.
    --- @type number
    rocks_yield_ore_distance_modifier = 0,

    --- Defines base amount of ores mined.
    --- @type number
    rocks_yield_ore_base_amount = 0,

    --- Defines maximum(capped) amount of ores that can mined.
    --- @type number
    rocks_yield_ore_maximum_amount = 0,

    --- Amount of discovered cells.
    --- @type number
    discovered_cells = 0,

    --- Fluids placed by the player. Keys are stringified fluid names.
    --- @type Dictionary<string, boolean>
    fluids_placed = {},

    --- Generated map cells. Keys are stringified cell's coordinates. 1_1, 1_2, 2_1, etc.
    --- @type Dictionary<string, MapCell>
    map_cells = {},
}

--- @class MinerTable
local MinerTable = {
    --- Amount of rocks broken.
    --- @type number
    rocks_broken = 0,

    --- Amount of ores mined.
    --- @type number
    ores_mined = 0,
}

--- @class PlayerStats
local PlayerStats = {
    --- Current pickaxe tier.
    --- @type number
    pickaxe_tier = 1,
}

--- @class MapCell
local mapCell = {
    --- Is the cell discovered?
    --- @type boolean
    visited = false,
}