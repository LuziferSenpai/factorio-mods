local modName = "__molten-tungsten__"
local meld = require("__core__/lualib/meld")

data:extend({
    meld(table.deepcopy(data.raw.fluid["molten-iron"]), {
        name = "molten-tungsten",
        icon = modName .. "/graphics/molten-tungsten.png",
        order = "b[new-fluid]-b[vulcanus]-c[molten-tungsten]",
        base_color = { 70, 58, 72 },
        flow_color = { 91, 70, 90 },
    }),
    meld(table.deepcopy(data.raw.recipe["tungsten-plate"]), {
        name = "molten-tungsten",
        order = "c[tungsten]-d[molten-tungsten]",
        results = { { type = "fluid", name = "molten-tungsten", amount = 10 } },
    })
})

table.insert(data.raw.technology["tungsten-steel"].effects, {
    type = "unlock-recipe",
    recipe = "molten-tungsten"
})
