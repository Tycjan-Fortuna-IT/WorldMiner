data:extend {
    {
        type = "item",
        name = "crystal-extractor",
        icons = {
            {
                icon = "__WorldMiner__/graphics/crystal-extractor/crystal-extractor-icon.png",
                icon_size = 128,
            }
        },
        order = "c",
        stack_size = 10,
        place_result = "crystal-extractor",
    },
    {
        type = "assembling-machine",
        name = "crystal-extractor",
        icon = "__WorldMiner__/graphics/crystal-extractor/crystal-extractor-icon.png",
        icon_size = 64,
        flags = { "placeable-neutral", "player-creation" },
        minable = { mining_time = 1, result = "crystal-extractor" },
        max_health = 600,
        corpse = "medium-remnants",
        dying_explosion = "medium-explosion",
        collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        crafting_categories = { "smelting" },
        crafting_speed = 1,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            emissions_per_minute = 0.06,
        },
        energy_usage = "1.2MW",
        animation = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/crystal-extractor/crystal-extractor-base.png",
                    width = 128,
                    height = 128,
                    line_length = 16,
                    frame_count = 16,
                    shift = { 0.3, -1.0 },
                    animation_speed = 0.9
                },
            }
        
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
        working_sound = {
            sound = { filename = "__WorldMiner__/sounds/crystal-extractor/working_sound.ogg", volume = 0.5 },
            idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
            apparent_volume = 2.5,
            audible_distance_modifier = 0.5,
        },
    }
}
