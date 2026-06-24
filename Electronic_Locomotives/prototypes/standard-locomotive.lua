local meld = require("__core__.lualib.meld")
local standardElectronicIcons = require("prototypes/util")
local name = "electronic-standard-locomotive"
local color = "#53bb90"

data:extend({
    meld(table.deepcopy(data.raw["locomotive"]["locomotive"]), {
        name = name,
        icon = meld.delete(),
        icons = standardElectronicIcons(color),
        minable = { result = name },
        color = util.color(color),
        localised_description = { "", { "entity-description.locomotive" }, "\n", { "electronic-locomotives.locomotive-description" } },
        is_electronic = true
    }),
    meld(table.deepcopy(data.raw["item-with-entity-data"]["locomotive"]), {
        name = name,
        icons = standardElectronicIcons(color),
        order = "c[rolling-stock]-ab[" .. name .. "]",
        place_result = name
    }),
    meld(table.deepcopy(data.raw["recipe"]["locomotive"]), {
        name = name,
        ingredients = meld.overwrite({
            { type = "item", name = "locomotive", amount = 1 },
            { type = "item", name = "battery", amount = 10 },
            { type = "item", name = "electric-engine-unit", amount = 20 }
        }),
        results = { { name = name } }
    })
})