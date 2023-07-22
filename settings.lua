data:extend({
    {
        type = "double-setting",
        name = "rocks-yield-ore-distance-modifier",
        setting_type = "startup",
        default_value = 0.25,
        minimum_value = 0,
        maximum_value = 1,
        order = "a"
    },
    {
        type = "int-setting",
        name = "rocks-yield-ore-base-amount",
        setting_type = "startup",
        default_value = 35,
        minimum_value = 0,
        maximum_value = 1000,
        order = "b"
    },
    {
        type = "int-setting",
        name = "rocks-yield-ore-maximum-amount",
        setting_type = "startup",
        default_value = 150,
        minimum_value = 0,
        maximum_value = 1000,
        order = "c"
    }
})
