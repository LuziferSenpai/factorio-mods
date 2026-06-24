local meld = require("__core__.lualib.meld")
local standardElectronicIcons = require("prototypes.util")
local name = "electronic-cargo-locomotive"
local color = "#a61a1a"

data:extend({
    meld(table.deepcopy(data.raw["locomotive"]["locomotive"]), {
        name = name,
        icon = meld.delete(),
        icons = standardElectronicIcons(color),
        minable = { result = name },
        max_health = 2000,
        weight = 5000,
        max_speed = 3,
        max_power = "3MW",
        reversing_power_modifier = 1.2,
        braking_force = 20,
        color = util.color(color),
        localised_description = { "", { "entity-description.locomotive" }, "\n", { "electronic-locomotives.locomotive-description" } },
        is_electronic = true
    }),
    meld(table.deepcopy(data.raw["item-with-entity-data"]["locomotive"]), {
        name = name,
        icons = standardElectronicIcons(color),
        order = "c[rolling-stock]-ac[" .. name .. "]",
        place_result = name
    }),
    meld(table.deepcopy(data.raw["recipe"]["locomotive"]), {
        name = name,
        ingredients = meld.overwrite({
            { type = "item", name = "electronic-standard-locomotive", amount = 1 },
            { type = "item", name = "battery", amount = 20 },
            { type = "item", name = "electric-engine-unit", amount = 20 }
        }),
        results = { { name = name } }
    })
})