-- _____________________________________________________________________________________________
-- This file was automatically generated Tue Aug 15 2023 17:42:35 UTC by FactorioLuaHelper.
-- _____________________________________________________________________________________________

data:extend({
{
	name = "dungeon-entrance",
	type = "simple-entity",
	order = "d",
	collision_box = { { -3.0, -3.0 }, { 3.0, 3.0 } },
	selection_box = { { -3.0, -3.0 }, { 3.0, 3.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 100000,
	pictures = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/dungeon-entrance/dungeon-entrance.png",
				width = 256,
				height = 256,
				priority = "extra-high",
				shift = { 1, -0.15 },
			},
		},
	},
},
{
	name = "green-banner",
	type = "simple-entity",
	order = "b[banner]-green",
	collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 100000,
	pictures = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/banner/green-banner.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
			{
				filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
		},
	},
},
{
	name = "purple-banner",
	type = "simple-entity",
	order = "b[banner]-purple",
	collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 100000,
	pictures = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
			{
				filename = "__WorldMiner__/graphics/banner/purple-banner.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
		},
	},
},
{
	name = "red-banner",
	type = "simple-entity",
	order = "b[banner]-red",
	collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 100000,
	pictures = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
			{
				filename = "__WorldMiner__/graphics/banner/red-banner.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
		},
	},
},
{
	name = "yellow-banner",
	type = "simple-entity",
	order = "b[banner]-",
	collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 100000,
	pictures = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
			{
				filename = "__WorldMiner__/graphics/banner/yellow-banner.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
		},
	},
},
{
	name = "blue-banner",
	type = "simple-entity",
	order = "b[banner]-blue",
	collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 100000,
	pictures = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
			{
				filename = "__WorldMiner__/graphics/banner/blue-banner.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
		},
	},
},
{
	name = "gray-banner",
	type = "simple-entity",
	order = "b[banner]-gray",
	collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 100000,
	pictures = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
			{
				filename = "__WorldMiner__/graphics/banner/gray-banner.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
		},
	},
},
{
	name = "black-banner",
	type = "simple-entity",
	order = "b[banner]-black",
	collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 100000,
	pictures = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
			{
				filename = "__WorldMiner__/graphics/banner/black-banner.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
		},
	},
},
{
	name = "orange-banner",
	type = "simple-entity",
	order = "b[banner]-orange",
	collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 100000,
	pictures = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
			{
				filename = "__WorldMiner__/graphics/banner/orange-banner.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
		},
	},
},
{
	name = "white-banner",
	type = "simple-entity",
	order = "b[banner]-white",
	collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 100000,
	pictures = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/banner/banner-shadow.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
			{
				filename = "__WorldMiner__/graphics/banner/white-banner.png",
				width = 500,
				height = 500,
				priority = "extra-high",
				shift = { -1.5, -3 },
			},
		},
	},
},
{
	name = "crystal-extractor",
	type = "assembling-machine",
	order = "c",
	collision_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	selection_box = { { -1.0, -1.0 }, { 1.0, 1.0 } },
	vehicle_impact_sound = {
		filename = "__base__/sound/car-metal-impact.ogg",
		volume = 0.5,
	},
	corpse = "medium-remnants",
	max_health = 600,	
	flags = {	
		"placeable-neutral",	
		"player-creation",	
	},	
	icons = {
		{
			icon = "__WorldMiner__/graphics/crystal-extractor/crystal-extractor-icon.png",
			icon_size = 64,
		},	
	},	
	minable = {	
		mining_time = 1,	
		result = "crystal-extractor",	
	},	
	dying_explosion = "medium-explosion",	
	crafting_categories = {	
		"smelting",	
	},	
	crafting_speed = 1,	
	energy_source = {	
		type = "electric",	
		usage_priority = "secondary-input",	
		emissions_per_minute = 0.6,	
	},	
	energy_usage = "1.2MW",	
	working_sound = {	
		sound = {	
			filename = "__WorldMiner__/sounds/crystal-extractor/working_sound.ogg",	
			volume = 0.5,	
		},	
		idle_sound = {	
			filename = "__base__/sound/idle1.ogg",	
			volume = 0.6,	
		},	
		audible_distance_modifier = 0.5,	
		apparent_volume = 2.5,	
	},
	animation = {
		layers = {
			{
				filename = "__WorldMiner__/graphics/crystal-extractor/crystal-extractor-base.png",
				width = 128,
				height = 128,
				line_length = 16,
				frame_count = 16,
				animation_speed = 0.9,
				shift = { 0.3, -1 },
			},
		},
	},
},
})