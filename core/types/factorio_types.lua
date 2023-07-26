-- I love types, but lua doesn't have them. So we have to document our types manually.

--- @class Player
local Player = {
    --- Inventory slots bonus.
    --- @type number
    character_inventory_slots_bonus = 0,

    --- Unique player indentifier.
    --- @type number
    index = 0,

    --- Mining speed modifier.
    --- @type number
    mining_speed_modifier = 0,

    --- Print a message to the player's chat.
    --- @type function
    --- @return nil
    print = function() end,
}

--- @class Market
local Market = {
    --- Get all offers in a market as an array.
    --- @type function
    --- @return array<Offer>
    get_market_items = function() return {} end,

    --- Clear all offers in a market.
    --- @type function
    --- @return nil
    clear_market_items = function() end,

    --- Add an offer to a market.
    --- @type function
    --- @param offer Offer
    --- @return nil
    add_market_item = function(offer) end,

    --- Market's force.
    --- @type LuaForce
    force = nil,
}

--- @class LuaEntity
local LuaEntity = {
    --- The name of this entity.
    --- @type string
    name = '',

    --- The surface this entity is on.
    --- @type LuaSurface
    surface = nil,

    --- The position of this entity.
    --- @type table|Tuple
    position = {},
}

--- @class LuaSurface
local LuaSurface = {
    --- Spill an item stack on the ground.
    --- @type function
    --- @param position Table|Tuple Center position of the spill.
    --- @param stack ItemStack The item stack to spill.
    --- @param enable_looted boolean? If true, the item stack will be marked as looted.
    --- @param force LuaForce? When provided (and not nil) the items will be marked for deconstruction by this force.
    --- @param allow_belts boolean? Whether items can be spilled onto belts. Defaults to true.
    --- @return nil
    spill_item_stack = function(position, stack, enable_looted, force, allow_belts) end,

    --- Create a flying text entity.
    --- @type function
    --- @param params Table
    --- @return nil
    create_entity = function(params) end,
}

--- @class LuaInventory
local LuaInventory = {
    --- The name of this inventory.
    --- @type string
    name = '',

    --- The number of slots in this inventory.
    --- @type number
    slot_count = 0,

    --- The number of slots in this inventory that are currently occupied.
    --- @type number
    item_count = 0,

    --- The number of slots in this inventory that are currently occupied by items.
    --- @type function
    --- @return number
    get_item_count = function() return 1 end,

    --- The number of slots in this inventory that are currently occupied by items.
    --- @type function
    --- @return number
    get_contents = function() return 1 end,

    --- The number of slots in this inventory that are currently occupied by items.
    --- @type function
    --- @return number
    can_insert = function() return 1 end,

    --- The number of slots in this inventory that are currently occupied by items.
    --- @type function
    --- @return number
    insert = function() return 1 end,

    --- The number of slots in this inventory that are currently occupied by items.
    --- @type function
    --- @return number
    remove = function() return 1 end,
}

--- @class LuaForce
local LuaForce = {
    --- Play a sound for every player in this force.
    --- @type function
    --- @param params Table<string, Table|Tuple?, number?> Sound path, position, and volume modifier.
    --- @return nil
    play_sound = function(params) end,
}

-------------------------------------------------------------
--                          EVENTS
-------------------------------------------------------------

--- @class MarketEvent
local MarketEvent = {
    --- The player who bought the item.
    --- @type number
    player_index = 0,

    --- The item that was bought.
    --- @type number
    offer_index = 0,

    --- The market that the item was bought from.
    --- @type Market
    market = nil,
}

--- @class OnPlayerMinedEntityEvent
local OnPlayerMinedEntityEvent = {
    --- The player who mined the entity.
    --- @type number
    player_index = 0,

    --- The entity that was mined.
    --- @type LuaEntity
    entity = nil,

    --- The temporary inventory that holds the result of mining the entity.
    --- @type LuaInventory
    buffer = nil,

    --- Identifier of the event
    --- @type defines.events
    name = {},

    --- Tick when the event occurred.
    --- @type number
    tick = 0,
}