data:extend {
    {
        type = "simple-entity",
        name = "dungeon-entrance",
        collision_box = { { -3.0, -3.0 }, { 3.0, 3.0 } },
        selection_box = { { -3.0, -3.0 }, { 3.0, 3.0 } },
        max_health = 30000,
        pictures = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/dungeon-entrance/dungeon-entrance.png",
                    priority = "extra-high",
                    width = 256,
                    height = 256,
                    shift = { 1, -0.15 },
                    hr_version = nil,
                }
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    },
}