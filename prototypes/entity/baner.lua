data:extend {
    -- ITEMS
    {
        type = "item",
        name = "green-banner",
        icons = {
            {
                icon = "__WorldMiner__/graphics/banner/green-banner-icon.png",
                icon_size = 64,
            }
        },
        flags = {},
        order = "b[banner]-green",
        stack_size = 1,
        place_result = "green-banner",
    },
    {
        type = "item",
        name = "purple-banner",
        icons = {
            {
                icon = "__WorldMiner__/graphics/banner/purple-banner-icon.png",
                icon_size = 64,
            }
        },
        flags = {},
        order = "b[banner]-purple",
        stack_size = 1,
        place_result = "purple-banner",
    },
    {
        type = "item",
        name = "red-banner",
        icons = {
            {
                icon = "__WorldMiner__/graphics/banner/red-banner-icon.png",
                icon_size = 64,
            }
        },
        flags = {},
        order = "b[banner]-red",
        stack_size = 1,
        place_result = "red-banner",
    },
    {
        type = "item",
        name = "yellow-banner",
        icons = {
            {
                icon = "__WorldMiner__/graphics/banner/yellow-banner-icon.png",
                icon_size = 64,
            }
        },
        flags = {},
        order = "b[banner]-yellow",
        stack_size = 1,
        place_result = "yellow-banner",
    },
    {
        type = "item",
        name = "blue-banner",
        icons = {
            {
                icon = "__WorldMiner__/graphics/banner/blue-banner-icon.png",
                icon_size = 64,
            }
        },
        flags = {},
        order = "b[banner]-blue",
        stack_size = 1,
        place_result = "blue-banner",
    },
    {
        type = "item",
        name = "gray-banner",
        icons = {
            {
                icon = "__WorldMiner__/graphics/banner/gray-banner-icon.png",
                icon_size = 64,
            }
        },
        flags = {},
        order = "b[banner]-gray",
        stack_size = 1,
        place_result = "gray-banner",
    },
    {
        type = "item",
        name = "black-banner",
        icons = {
            {
                icon = "__WorldMiner__/graphics/banner/black-banner-icon.png",
                icon_size = 64,
            }
        },
        flags = {},
        order = "b[banner]-black",
        stack_size = 1,
        place_result = "black-banner",
    },
    {
        type = "item",
        name = "orange-banner",
        icons = {
            {
                icon = "__WorldMiner__/graphics/banner/orange-banner-icon.png",
                icon_size = 64,
            }
        },
        flags = {},
        order = "b[banner]-orange",
        stack_size = 1,
        place_result = "orange-banner",
    },
    {
        type = "item",
        name = "white-banner",
        icons = {
            {
                icon = "__WorldMiner__/graphics/banner/white-banner-icon.png",
                icon_size = 64,
            }
        },
        flags = {},
        order = "b[banner]-white",
        stack_size = 1,
        place_result = "white-banner",
    },
    -- ENTITIES
    {
        type = "simple-entity",
        name = "green-banner",
        collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        max_health = 300,
        pictures = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/banner/green-banner.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
                {
                    filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    draw_as_shadow = true,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    },
    {
        type = "simple-entity",
        name = "purple-banner",
        collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        max_health = 300,
        pictures = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/banner/purple-banner.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
                {
                    filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    draw_as_shadow = true,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    },
    {
        type = "simple-entity",
        name = "red-banner",
        collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        max_health = 300,
        pictures = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/banner/red-banner.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
                {
                    filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    draw_as_shadow = true,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    },
    {
        type = "simple-entity",
        name = "yellow-banner",
        collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        max_health = 300,
        pictures = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/banner/yellow-banner.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
                {
                    filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    draw_as_shadow = true,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    },
    {
        type = "simple-entity",
        name = "blue-banner",
        collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        max_health = 300,
        pictures = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/banner/blue-banner.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
                {
                    filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    draw_as_shadow = true,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    },
    {
        type = "simple-entity",
        name = "gray-banner",
        collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        max_health = 300,
        pictures = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/banner/gray-banner.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
                {
                    filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    draw_as_shadow = true,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    },
    {
        type = "simple-entity",
        name = "black-banner",
        collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        max_health = 300,
        pictures = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/banner/black-banner.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
                {
                    filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    draw_as_shadow = true,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    },
    {
        type = "simple-entity",
        name = "orange-banner",
        collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        max_health = 300,
        pictures = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/banner/orange-banner.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
                {
                    filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    draw_as_shadow = true,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    },
    {
        type = "simple-entity",
        name = "white-banner",
        collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
        max_health = 300,
        pictures = {
            layers = {
                {
                    filename = "__WorldMiner__/graphics/banner/white-banner.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
                {
                    filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
                    priority = "extra-high",
                    width = 500,
                    height = 500,
                    draw_as_shadow = true,
                    shift = { -1.5, -3 },
                    hr_version = nil,
                },
            },
        },
        vehicle_impact_sound = { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.65 },
    }
}
