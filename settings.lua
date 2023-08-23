data:extend{
    {
        type = "double-setting",
        name = "rocks-yield-ore-distance-modifier",
        setting_type = "startup",
        default_value = 0.15,
        minimum_value = 0,
        maximum_value = 1,
        order = "a"
    },
    {
        type = "int-setting",
        name = "rocks-yield-ore-base-amount",
        setting_type = "startup",
        default_value = 18,
        minimum_value = 0,
        maximum_value = 1000,
        order = "b"
    },
    {
        type = "int-setting",
        name = "rocks-yield-ore-maximum-amount",
        setting_type = "startup",
        default_value = 300,
        minimum_value = 0,
        maximum_value = 1000,
        order = "c"
    },
    {
        type = "bool-setting",
        name = "generate-more-rocks-from-start",
        setting_type = "startup",
        default_value = false,
        order = "d"
    },
    {
        type = "bool-setting",
        name = "generate-more-trees-from-start",
        setting_type = "startup",
        default_value = false,
        order = "d"
    },
    {
        type = "bool-setting",
        name = "rocks-yield-enemies",
        setting_type = "startup",
        default_value = true,
        order = "e"
    },
    {
        type = "bool-setting",
        name = "rocks-yield-loot",
        setting_type = "startup",
        default_value = false,
        order = "f",
        hidden  = true
    },
    {
        type = "bool-setting",
        name = "trees-yield-ore",
        setting_type = "startup",
        default_value = true,
        order = "g"
    },
    {
        type = "double-setting",
        name = "ore-richness-multiplier",
        setting_type = "runtime-global",
        minimum_value = 0.01,
        maximum_value = 100,
        default_value = 1,
        order = "h",
    },
    {
        type = "double-setting",
        name = "oil-richness-multiplier",
        setting_type = "runtime-global",
        minimum_value = 0.01,
        maximum_value = 100,
        default_value = 1,
        order = "h",
    },
}
