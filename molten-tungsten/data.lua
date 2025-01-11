local modName = "__molten-tungsten__"
local meld = require("__core__/lualib/meld")
local tungstenPlateRecipe = data.raw.recipe["tungsten-plate"]
local tungstenPlateItem = data.raw.item["tungsten-plate"]
local defaultIconSizeDefine = defines.default_icon_size

data:extend({
    meld(table.deepcopy(data.raw.fluid["molten-iron"]), {
        name = "molten-tungsten",
        icon = modName .. "/graphics/molten-tungsten.png",
        order = "b[new-fluid]-b[vulcanus]-c[molten-tungsten]",
        base_color = { 70, 58, 72 },
        flow_color = { 91, 70, 90 }
    }),
    meld(table.deepcopy(tungstenPlateRecipe), {
        name = "molten-tungsten",
        order = "c[tungsten]-d[molten-tungsten]",
        results = { { type = "fluid", name = "molten-tungsten", amount = 10 } },
    }),
    meld(table.deepcopy(tungstenPlateRecipe), {
        name = "casting-tungsten",
        icon = meld.delete(),
        icons = {
            {
                icon = modName .. "/graphics/64x64-empty.png",
                icon_size = 64
            },
            {
                icon = tungstenPlateItem.icon,
                icon_size = tungstenPlateItem.icon_size,
                scale = (0.5 * defaultIconSizeDefine / (tungstenPlateItem.icon_size or defaultIconSizeDefine)) * 0.8125,
                shift = { 0, 20 / 2 },
                draw_background = true
            },
            {
                icon = modName .. "/graphics/molten-tungsten.png",
                icon_size = 64,
                scale = (0.5 * defaultIconSizeDefine / 64) * 0.8125,
                shift = { 19 / 2, -2 / 2 },
                draw_background = true
            }
        },
        localised_name = { "molten-tungsten.casting", {"item-name.tungsten-plate"} },
        order = "c[tungsten]-e[casting-tungsten]",
        ingredients = meld.overwrite({
            { type = "fluid", name = "molten-tungsten", amount = 10, fluidbox_multiplier = 5 }
        }),
        allow_decomposition = false,
        allow_productivity = false
    })
})

table.insert(data.raw.technology["tungsten-steel"].effects, {
    type = "unlock-recipe",
    recipe = "molten-tungsten"
})

table.insert(data.raw.technology["tungsten-steel"].effects, {
    type = "unlock-recipe",
    recipe = "casting-tungsten"
})
