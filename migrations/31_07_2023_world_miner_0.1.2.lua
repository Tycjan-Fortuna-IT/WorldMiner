local rooms1x1 = require("core.variants.1x1")
local rooms1x2 = require("core.variants.1x2")
local rooms1x3 = require("core.variants.1x3")
local rooms2x2 = require("core.variants.2x2")
local rooms2x3 = require("core.variants.2x3")
local rooms3x3 = require("core.variants.3x3")
local variant_dungeon = require("core.variants.dungeon")

local variant_dispatcher = require("core.variants.variant_dispatcher")

rooms1x1.init()
rooms1x2.init()
rooms1x3.init()
rooms2x2.init()
rooms2x3.init()
rooms3x3.init()
variant_dungeon.init()

if not variant_dispatcher.variants then
    variant_dispatcher.variants = {
        { name = '1x1', variant = rooms1x1, weight = 36, min_discovered_rooms = 0, max_discovered_rooms = 0, guaranteed_at = { 1 } },
        { name = '1x2', variant = rooms1x2, weight = 18, min_discovered_rooms = 12, max_discovered_rooms = 0, guaranteed_at = { 5 } },
        { name = '1x3', variant = rooms1x3, weight = 9, min_discovered_rooms = 18, max_discovered_rooms = 0, guaranteed_at = { 10 } },
        { name = '2x2', variant = rooms2x2, weight = 5, min_discovered_rooms = 24, max_discovered_rooms = 0, guaranteed_at = { 25 } },
        { name = '2x3', variant = rooms2x3, weight = 3, min_discovered_rooms = 33, max_discovered_rooms = 0, guaranteed_at = { 34 } },
        { name = '3x3', variant = rooms3x3, weight = 2, min_discovered_rooms = 45, max_discovered_rooms = 0, guaranteed_at = { 46 } },
        { name = 'dungeon', variant = variant_dungeon, weight = 3, min_discovered_rooms = 50, max_discovered_rooms = 0, guaranteed_at = { 51 } },
    }
end

global.map_cells = global.map_cells or {}
global.discovered_cells = global.discovered_cells or 1
global.discovered_rooms = global.discovered_rooms or 1
global.fluids_placed = global.fluids_placed or {}
global.player_stats = global.player_stats or {}
global.variants = global.variants or {}

for _, variant in pairs(variant_dispatcher.variants) do
    global.variants[variant.name] = global.variants[variant.name] or { discovered_rooms = 1 }
end