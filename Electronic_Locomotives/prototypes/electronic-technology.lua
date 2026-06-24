local meld = require("__core__.lualib.meld")
local modName = "__Electronic_Locomotives__"
local electronicTech = {
    type = "technology",
    icon = modName .. "/graphics/electronic-railway.png",
    icon_size = 256,
    unit = {
        time = 60
    },
    upgrade = true
}

data:extend({
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives",
        effects = {
            {
                type = "unlock-recipe",
                recipe = "electronic-standard-provider"
            },
            {
                type = "unlock-recipe",
                recipe = "electronic-standard-locomotive"
            }
        },
        prerequisites = { "railway", "electric-engine", "battery", "electric-energy-distribution-2" },
        unit = {
            count = 400,
            time = 60,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 1 }
            }
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-2",
        effects = meld.overwrite({
            {
                type = "unlock-recipe",
                recipe = "electronic-cargo-locomotive"
            }
        }),
        prerequisites = { "electronic-locomotives" },
        unit = {
            count = 800,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 1 },
                { "production-science-pack", 1 }
            }
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-3",
        localised_description = { "electronic-locomotives.description", "1.2", "1.05" },
        prerequisites = { "electronic-locomotives-2" },
        unit = {
            count = 1000,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 1 },
                { "production-science-pack", 1 }
            }
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-4",
        localised_description = { "electronic-locomotives.description", "1.8", "1.15" },
        prerequisites = { "electronic-locomotives-3" },
        unit = {
            count = 1200,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 1 },
                { "production-science-pack", 1 },
                { "utility-science-pack", 1 }
            }
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-5",
        localised_description = { "electronic-locomotives.description", "2.5", "1.15" },
        prerequisites = { "electronic-locomotives-4" },
        unit = {
            count = 1400,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 1 },
                { "production-science-pack", 1 },
                { "utility-science-pack", 1 }
            }
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-6",
        localised_description = { "electronic-locomotives.description", "3.5", "1.75" },
        prerequisites = { "electronic-locomotives-5" },
        unit = {
            count = 2000,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 1 },
                { "production-science-pack", 1 },
                { "utility-science-pack", 1 },
                { "space-science-pack", 1 }
            }
        }
    }),
    meld(table.deepcopy(electronicTech), {
        name = "electronic-locomotives-7",
        prerequisites = { "electronic-locomotives-6" },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "electronic-heavy-provider"
            }
        },
        unit = {
            count = 10000,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 1 },
                { "production-science-pack", 1 },
                { "utility-science-pack", 1 },
                { "space-science-pack", 1 }
            }
        }
    })
})