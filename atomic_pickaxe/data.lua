local meld = require("__core__.lualib.meld")

data:extend({
    meld(table.deepcopy(data.raw.technology["steel-axe"]), {
        name = "atomic-pickaxe",
        icon = "__atomic_pickaxe__/atomic-pickaxe.png",
        effects = { { type = "character-mining-speed", modifier = 10 } },
        prerequisites = { "steel-axe", "uranium-processing" },
        research_trigger = {
            type = "mine-entity",
            entities = { "uranium-ore" }
        }
    })
})
