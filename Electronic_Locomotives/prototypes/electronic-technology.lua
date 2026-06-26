local meld = require("__core__.lualib.meld")
local modName = "__Electronic_Locomotives__"

---@type data.TechnologyPrototype
local electronicTech = {
    name = "",
    type = "technology",
    icon = modName .. "/graphics/electronic-railway.png",
    icon_size = 256,
    unit = {
        time = 60,
        ingredients = {}
    },
    upgrade = true
}

local auto = { "automation-science-pack", 1 }
local log = { "logistic-science-pack", 1 }
local chem = { "chemical-science-pack", 1 }
local prod = { "production-science-pack", 1 }
local util = { "utility-science-pack", 1 }
local space = { "space-science-pack", 1 }

---@param acceleration number
---@param topSpeed number
---@return TechnologyModifier.nothing
local function fuelEffect(acceleration, topSpeed)
    return {
        type = "nothing",
        icon = modName .. "/graphics/electric-32.png",
        icon_size = 32,
        effect_description = { "electronic-locomotives.description", tostring(acceleration), tostring(topSpeed) }
    }
end

---@param recipeName string
---@return TechnologyModifier.unlock_recipe
local function recipeEffect(recipeName)
    return { type = "unlock-recipe", recipe = recipeName }
end

data:extend({
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives",
        effects = {
            recipeEffect("electronic-locomotive-1"),
            recipeEffect("electronic-provider-1")
        },
        prerequisites = { "railway", "electric-engine", "battery", "electric-energy-distribution-2" },
        unit = {
            count = 400,
            ingredients = meld.overwrite({ auto, log, chem })
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-2",
        effects = {
            recipeEffect("electronic-locomotive-2"),
        },
        prerequisites = { "electronic-locomotives", "advanced-circuit", "production-science-pack" },
        unit = {
            count = 600,
            ingredients = meld.overwrite({ auto, log, chem, prod })
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-3",
        effects = {
            recipeEffect("electronic-provider-2"),
            fuelEffect(1.3, 1.1)
        },
        prerequisites = { "electronic-locomotives-2" },
        unit = {
            count = 800,
            ingredients = meld.overwrite({ auto, log, chem, prod })
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-4",
        effects = {
            recipeEffect("electronic-locomotive-3")
        },
        prerequisites = { "electronic-locomotives-3", "processing-unit", "utility-science-pack" },
        unit = {
            count = 1000,
            ingredients = meld.overwrite({ auto, log, chem, prod, util })
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-5",
        effects = {
            recipeEffect("electronic-provider-3"),
            fuelEffect(1.7, 1.2)
        },
        prerequisites = { "electronic-locomotives-4" },
        unit = {
            count = 1200,
            ingredients = meld.overwrite({ auto, log, chem, prod, util })
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-6",
        effects = {
            recipeEffect("electronic-locomotive-4")
        },
        prerequisites = { "electronic-locomotives-5", "low-density-structure" },
        unit = {
            count = 1400,
            ingredients = meld.overwrite({ auto, log, chem, prod, util })
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-7",
        effects = {
            fuelEffect(2.2, 1.35)
        },
        prerequisites = { "electronic-locomotives-6", "space-science-pack" },
        unit = {
            count = 1800,
            ingredients = meld.overwrite({ auto, log, chem, prod, util, space })
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-8",
        effects = {
            recipeEffect("electronic-locomotive-5"),
            recipeEffect("electronic-provider-4")
        },
        prerequisites = { "electronic-locomotives-7" },
        unit = {
            count = 2200,
            ingredients = meld.overwrite({ auto, log, chem, prod, util, space })
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-9",
        effects = {
            fuelEffect(3, 1.5)
        },
        prerequisites = { "electronic-locomotives-8" },
        unit = {
            count = 2600,
            ingredients = meld.overwrite({ auto, log, chem, prod, util, space })
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-10",
        effects = {
            recipeEffect("electronic-locomotive-6")
        },
        prerequisites = { "electronic-locomotives-9", "speed-module-2" },
        unit = {
            count = 3000,
            ingredients = meld.overwrite({ auto, log, chem, prod, util, space })
        }
    })
})