local modName = "__Electronic_Locomotives__"
local meld = require("__core__.lualib.meld")
local firstNamePart = "electronic-locomotive-"
local locomotiveEntity = data.raw.locomotive.locomotive
local locomotiveItem = data.raw["item-with-entity-data"].locomotive
local locomotiveRecipe = data.raw.recipe.locomotive

---@type table<int, { hex : string, maxHealth : int, weight : int, maxSpeed : number, maxPower : string, reverseMod : number, brakingForce : int, ingredients : table<int, data.IngredientPrototype[]> }>
local tiers = {
    {
        hex = "#EA0F00",
        maxHealth = 1000,
        weight = 2000,
        maxSpeed = 1.2,
        maxPower = "600kW",
        reverseMod = 0.6,
        brakingForce = 10,
        ingredients = {
            { type = "item", name = "battery", amount = 10 },
            { type = "item", name = "electric-engine-unit", amount = 20 }
        }
    },
    {
        hex = "#4A90D9",
        maxHealth = 1500,
        weight = 2500,
        maxSpeed = 1.5,
        maxPower = "1MW",
        reverseMod = 0.75,
        brakingForce = 13,
        ingredients = {
            { type = "item", name = "battery", amount = 15 },
            { type = "item", name = "advanced-circuit", amount = 5 },
            { type = "item", name = "steel-plate", amount = 5 }
        }
    },
    {
        hex = "#57C26A",
        maxHealth = 2000,
        weight = 3000,
        maxSpeed = 1.8,
        maxPower = "1.6MW",
        reverseMod = 0.85,
        brakingForce = 16,
        ingredients = {
            { type = "item", name = "battery", amount = 20 },
            { type = "item", name = "advanced-circuit", amount = 10 },
            { type = "item", name = "steel-plate", amount = 10 }
        }
    },
    {
        hex = "#E8A838",
        maxHealth = 2500,
        weight = 3500,
        maxSpeed = 2.1,
        maxPower = "2.5MW",
        reverseMod = 0.95,
        brakingForce = 20,
        ingredients = {
            { type = "item", name = "battery", amount = 25 },
            { type = "item", name = "processing-unit", amount = 15 },
            { type = "item", name = "steel-plate", amount = 10 }
        }
    },
    {
        hex = "#C44D8A",
        maxHealth = 3000,
        weight = 4000,
        maxSpeed = 2.4,
        maxPower = "3.5MW",
        reverseMod = 1.1,
        brakingForce = 25,
        ingredients = {
            { type = "item", name = "battery", amount = 30 },
            { type = "item", name = "processing-unit", amount = 20 },
            { type = "item", name = "low-density-structure", amount = 10 }
        }
    },
    {
        hex = "#4DD9C4",
        maxHealth = 4000,
        weight = 5000,
        maxSpeed = 3.0,
        maxPower = "5MW",
        reverseMod = 1.3,
        brakingForce = 32,
        ingredients = {
            { type = "item", name = "battery", amount = 40 },
            { type = "item", name = "processing-unit", amount = 30 },
            { type = "item", name = "low-density-structure", amount = 20 },
            { type = "item", name = "speed-module-2", amount = 5 }
        }
    }
}

---@param color string
---@return data.IconData[]
local function standardElectronicIcons(color)
    return {
        {
            icon = modName .. "/graphics/locomotive-base.png",
            icon_size = 64
        },
        {
            icon = modName .. "/graphics/locomotive-mask.png",
            icon_size = 64,
            tint = util.color(color)
        },
        {
            icon = modName .. "/graphics/electric-32.png",
            icon_size = 32,
            scale = 0.5,
            shift = { -5, -5 }
        }
    }
end

for i = 1, #tiers do
    local name = firstNamePart .. i
    local electronicData = tiers[i]
    local icons = standardElectronicIcons(electronicData.hex)

    table.insert(electronicData.ingredients, 1, { type = "item", name = (i == 1) and "locomotive" or firstNamePart .. (i - 1), amount = 1 })

    data:extend({
        meld(table.deepcopy(locomotiveEntity), {
            name = name,
            icon = meld.delete(),
            icons = icons,
            minable = { result = name },
            max_health = electronicData.maxHealth,
            weight = electronicData.weight,
            max_speed = electronicData.maxSpeed,
            max_power = electronicData.maxPower,
            reversing_power_modifier = electronicData.reverseMod,
            braking_force = electronicData.brakingForce,
            color = util.color(electronicData.hex),
            localised_description = { "", { "entity-description.locomotive" }, "\n", { "electronic-locomotives.locomotive-description" } },
            fast_replaceable_group = "electronic-locomotives",
            next_upgrade = i < #tiers and firstNamePart .. (i + 1) or nil,
            is_electronic = true
        }),
        meld(table.deepcopy(locomotiveItem), {
            name = name,
            icon = meld.delete(),
            icons = icons,
            order = "c[rolling-stock]-ab[" .. name .. "]",
            place_result = name
        }),
        meld(table.deepcopy(locomotiveRecipe), {
            name = name,
            ingredients = meld.overwrite(electronicData.ingredients),
            results = { { name = name } }
        })
    })
end