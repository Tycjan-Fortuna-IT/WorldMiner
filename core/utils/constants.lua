local C = {}

C.pickaxe_tiers = {
    'Wood', 'Plastic', 'Bone', 'Alabaster', 'Lead', 'Zinc', 'Tin', 'Salt', 'Bauxite', 'Borax',
    'Bismuth', 'Amber', 'Galena', 'Calcite', 'Aluminium', 'Silver', 'Gold', 'Copper', 'Marble',
    'Brass', 'Flourite', 'Platinum', 'Nickel', 'Iron', 'Manganese', 'Apatite', 'Uraninite',
    'Turquoise', 'Hematite', 'Glass', 'Magnetite', 'Concrete', 'Pyrite', 'Steel', 'Zircon',
    'Titanium', 'Silicon', 'Quartz', 'Garnet', 'Flint', 'Tourmaline', 'Beryl', 'Topaz',
    'Chrysoberyl', 'Chromium', 'Tungsten', 'Corundum', 'Tungsten', 'Diamond', 'Netherite',
    'Penumbrite', 'Meteorite', 'Crimtane', 'Obsidian', 'Demonite', 'Mythril', 'Adamantite',
    'Chlorophyte', 'Densinium', 'Luminite', 'Adamantium', 'Ebonite', 'Fools_Gold', 'Gorgonite',
    'Hellstone', 'Iridium', 'Jade', 'Kyanite', 'Lapis_Lazuli', 'Moonstone', 'Nether_Gold',
    'Orichalcum', 'Prismarite', 'Quantum_Crystal', 'Rainbow_Gem', 'Sapphire', 'Thaumium',
    'Vibranium', 'Warp_Stone', 'Xenotime', 'Yttrium', 'Zorgium',
    'Celestial', 'Cosmic', 'Ethereal', 'Galactic', 'Infinity', 'Mythical', 'Omega', 'Transcendent',
    'Supreme', 'Primordial', 'Apex', 'Ultimate', 'Exalted', 'Ascendant', 'Immortal', 'Titanic',
    'Almighty', 'Epic', 'Legendary', 'Mythic', 'Ancient', 'Divine', 'Fabled', 'Eternal', 'Godly',
    'Omnipotent', 'Transcendental', 'Unreal', 'Mythological', 'Supernatural', 'Infinite', 'Divine',
    'Mythical', 'Unparalleled', 'Mythopoeic', 'Peerless', 'Unearthly', 'Beyond',
    'Supersonic', 'Galactic', 'Celestial', 'Cosmic', 'Astral', 'Epic', 'Mythic', 'Mystic', 'Transcendent',
    'Infernal', 'Eternal', 'Mythological', 'Celestial', 'Omnipotent', 'Alpha', 'Omega', 'Divine', 'Prismatic',
    'Apex', 'Supreme', 'Enchanted', 'Imbued', 'Resplendent', 'Sublime', 'Mythopoeic', 'Empyrean', 'Chimeric',
    'Pristine', 'Peerless', 'Seraphic', 'Omniscient', 'Ethereal', 'Sublime', 'Primordial', 'Infinite', 'Arcane',
    'Mythical', 'Enigmatic', 'Empyreal', 'Exalted', 'Immutable', 'Sovereign', 'Elysian', 'Unfathomable', 'Legendary',
    'Transcendental', 'Unreal', 'Imperial', 'Ultimate', 'Unbound', 'Magnificent', 'Regal', 'Venerable', 'Mythopoeic',
    'Unsurpassable', 'Immeasurable', 'Stellar', 'Unearthly', 'Empyrean', 'Radiant', 'Apocalyptic', 'Sapient', 'Divine',
    'Exalted', 'Peerless', 'Ascendant', 'Godly', 'Supernatural', 'Transcendent', 'Infinite', 'Omnipotent', 'Eternal',
    'Celestial', 'Mythic', 'Unparalleled', 'Mythological', 'Mythical', 'Mythopoeic', 'Legendary', 'Immortal', 'Ultimate',
    'Primordial', 'Supreme', 'Cosmic', 'Divine', 'Ethereal', 'Astral', 'Galactic', 'Transcendent', 'Omega', 'Supersonic',
    'Enchanted', 'Mythical', 'Imbued', 'Infernal', 'Resplendent', 'Prismatic', 'Celestial', 'Empyreal', 'Sovereign',
    'Chimeric', 'Pristine', 'Peerless', 'Seraphic', 'Sublime', 'Omniscient', 'Ethereal', 'Arcane', 'Divine',
    'Mythological',
    'Mythical', 'Enigmatic', 'Exalted', 'Immutable', 'Regal', 'Elysian', 'Unfathomable', 'Legendary', 'Unreal',
    'Imperial',
    'Unbound', 'Ultimate', 'Magnificent', 'Venerable', 'Unsurpassable', 'Immeasurable', 'Unearthly', 'Radiant',
    'Empyrean'
}

C.base_loot_item_raffle = function()
    return {
        { { name = 'submachine-gun', count = math.random(1, 3) },              weight = 3, evolution_min = 0.0,                                                                                                                    evolution_max = 0.1 },
        { { name = 'shotgun', count = math.random(1, 2) },                     weight = 2, evolution_min = 0.0,                                                                                                                 evolution_max = 0.2 },
        { { name = 'piercing-rounds-magazine', count = math.random(50, 200) }, weight = 4, evolution_min = 0.1,                                                                                                                    evolution_max = 0.3 },
        { { name = 'grenade', count = math.random(10, 25) },                   weight = 2, evolution_min = 0.1,                                                                                                                   evolution_max = 0.4 },
        { { name = 'land-mine', count = math.random(10, 15) },                 weight = 1, evolution_min = 0.2,                                                                                                                 evolution_max = 0.5 },
        { { name = 'flamethrower', count = 1 },                                weight = 1, evolution_min = 0.3,                                                                                                              evolution_max = 0.6 },
        { { name = 'rocket-launcher', count = 1 },                             weight = 1, evolution_min = 0.4,                                                                                                                    evolution_max = 0.7 },
        { { name = 'explosive-rocket', count = math.random(5, 10) },           weight = 2, evolution_min = 0.5,                                                                                                                    evolution_max = 1.0 },
        { { name = 'assembling-machine-1', count = math.random(1, 3) },        weight = 2, evolution_min = 0.0,                                                                                                                    evolution_max = 0.2 },
        { { name = 'assembling-machine-2', count = math.random(1, 2) },        weight = 1, evolution_min = 0.2,                                                                                                                    evolution_max = 0.4 },
        { { name = 'assembling-machine-3', count = 1 },                        weight = 1, evolution_min = 0.5,                                                                                                                    evolution_max = 1.0 },
        { { name = 'electric-mining-drill', count = math.random(1, 3) },       weight = 2, evolution_min = 0.0,                                                                                                                    evolution_max = 0.3 },
        { { name = 'small-lamp', count = math.random(10, 15) },                weight = 1, evolution_min = 0.0,                                                                                                                    evolution_max = 1.0 },
        { { name = 'stone-wall', count = math.random(10, 50) },                weight = 3, evolution_min = 0.0,                                                                                                                    evolution_max = 0.5 },
        { { name = 'gun-turret', count = math.random(10, 15) },                weight = 2, evolution_min = 0.0,                                                                                                                    evolution_max = 0.3 },
        { { name = 'laser-turret', count = math.random(10, 25) },              weight = 1, evolution_min = 0.5,                                                                                                                    evolution_max = 1.0 },
        { { name = 'flamethrower-turret', count = 1 },                         weight = 1, evolution_min = 0.8,                                                                                                                    evolution_max = 1.0 },
        { { name = 'artillery-turret', count = 1 },                            weight = 1, evolution_min = 0.8,                                                                                                                    evolution_max = 1.0 },
        { { name = 'artillery-shell', count = math.random(10, 15) },           weight = 1, evolution_min = 0.8,                                                                                                                    evolution_max = 1.0 },
        { { name = 'car', count = 1 },                                         weight = 2, evolution_min = 0.2,                                                                                                                    evolution_max = 0.4 },
        { { name = 'tank', count = 1 },                                        weight = 1, evolution_min = 0.4,                                                                                                                    evolution_max = 1.0 },
        { { name = 'construction-robot', count = math.random(5, 20) },         weight = 3, evolution_min = 0.4,                                                                                                                    evolution_max = 1.0 },
        { { name = 'logistic-robot', count = math.random(5, 20) },             weight = 3, evolution_min = 0.4,                                                                                                                    evolution_max = 1.0 },
        { { name = 'roboport', count = math.random(1, 3) },                    weight = 2, evolution_min = 0.4,                                                                                                                    evolution_max = 1.0 },
        { { name = 'solar-panel', count = math.random(15, 20) },               weight = 3, evolution_min = 0.2,                                                                                                                    evolution_max = 0.7 },
        { { name = 'accumulator', count = math.random(15, 20) },               weight = 3, evolution_min = 0.2,                                                                                                                    evolution_max = 0.7 },
        { { name = 'nuclear-reactor', count = 1 },                             weight = 1, evolution_min = 0.9,                                                                                                               evolution_max = 1.0 },
        { { name = 'heat-exchanger', count = math.random(10, 13) },            weight = 2, evolution_min = 0.9,                                                                                                                evolution_max = 1.0 },
        { { name = 'steam-turbine', count = math.random(10, 13) },             weight = 2, evolution_min = 0.9,                                                                                                       evolution_max = 1.0 },
        { { name = 'satellite', count = 1 },                                   weight = 1, evolution_min = 0.9,                                                                                                        evolution_max = 1.0 },
        { { name = 'uranium-235', count = math.random(10, 50) },               weight = 1, evolution_min = 0.8,                                                                                                        evolution_max = 1.0 },
        { { name = 'uranium-238', count = math.random(10, 50) },               weight = 1, evolution_min = 0.8,                                                                                                        evolution_max = 1.0 },
        { { name = 'uranium-rounds-magazine', count = math.random(100, 200) }, weight = 2, evolution_min = 0.8,                                                                                                         evolution_max = 1.0 },
        { { name = 'atomic-bomb', count = 1 },                                 weight = 1, evolution_min = 0.9,                                                                                                         evolution_max = 1.0 },
        { { name = 'electronic-circuit', count = math.random(100, 500) },      weight = 4, evolution_min = 0.0,                                                                                                          evolution_max = 0.4 },
        { { name = 'advanced-circuit', count = math.random(100, 500) },        weight = 3, evolution_min = 0.5,                                                                                                                evolution_max = 0.8 },
        { { name = 'processing-unit', count = math.random(100, 200) },         weight = 3, evolution_min = 0.7,                                                                                                                 evolution_max = 1.0 },
    }
end

-- TODO
C.angels_loot_item_raffle = {

}

C.changelog = {
    {
        version = '0.1.4',
        date = '19.08.2023',
        desc = [[
Bugfixes:
* Fixed problems with config table and variant dispatcher not working correctly after save load
Major Features:
* New room variants: L-shape, T-shape, O-shape
* Oil room improvements
* GUI improvements
    ]]
    },
    {
        version = '0.1.3',
        date = '07.08.2023',
        desc = [[
Bugfixes:
* Fixed crash when exploring new rooms after save load
        ]]
    },
    {
        version = '0.1.2',
        date = '31.07.2023',
        desc = [[
Major Features:
* New room variants: 1x2, 1x3, 2x2, 2x3, 3x3
Minor Features:
* Rooms with enemies, ore veins and oil now feel a litle less empty
* More market items (ore exchange, backpack upgrade, blue coins currency)
* Rocks now have a chance to drop enemies in different stages of evolution (based on distance from center, can be disabled in settings)
* Gui can be closed now
* Banner placeables and items added for future dungeon rooms(different banner for different room type, difficulty, boss, etc...), crystal extractor
* Variant dispatcher overhaul, now it's more flexible
* Trees can yield ore (can be enabled in settings)
* Treasure chests can be found from mining rocks (can be disabled in settings)
Balancing:
* Less ore from rocks at the begining (now scales better with distance from center)
* Ore patches richness improved (now scales better with distance from center)
* Less rocks and trees in rooms (you still can have old quantity by enabling `More Rocks` and `More Trees` settings)
        ]]
    },
    {
        version = '0.1.1',
        date = '24.07.2023',
        desc = [[
Bugfixes:
* Additional fluid variant safety check
        ]]
    },
    {
        version = '0.1.0',
        date = '23.07.2023',
        desc = [[
Changes:
* Mod init
        ]]
    },
}

return C
