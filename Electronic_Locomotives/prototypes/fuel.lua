local meld = require("__core__.lualib.meld")
local modName = "__Electronic_Locomotives__"
local fuel = {
    type = "item",
    icon = modName .. "/graphics/electric-32.png",
    icon_size = 32,
    fuel_category = "electronic",
    fuel_value = "10MJ",
    subgroup = "raw-resource",
    order = "z[energy]",
    stack_size = 1,
    enabled = false,
    hidden = true
}

data:extend({
    meld(table.deepcopy(fuel), {
        name = "electronic-fuel-1",
        localised_name =  { "electronic-locomotives.fuel", "1" },
    }),
    meld(table.deepcopy(fuel), {
        name = "electronic-fuel-2",
        localised_name =  { "electronic-locomotives.fuel", "2" },
        fuel_acceleration_multiplier = 1.3,
        fuel_top_speed_multiplier = 1.1
    }),
    meld(table.deepcopy(fuel), {
        name = "electronic-fuel-3",
        localised_name =  { "electronic-locomotives.fuel", "3" },
        fuel_acceleration_multiplier = 1.7,
        fuel_top_speed_multiplier = 1.2
    }),
    meld(table.deepcopy(fuel), {
        name = "electronic-fuel-4",
        localised_name =  { "electronic-locomotives.fuel", "4" },
        fuel_acceleration_multiplier = 2.2,
        fuel_top_speed_multiplier = 1.35
    }),
    meld(table.deepcopy(fuel), {
        name = "electronic-fuel-5",
        localised_name =  { "electronic-locomotives.fuel", "5" },
        fuel_acceleration_multiplier = 3,
        fuel_top_speed_multiplier = 1.5
    })
})