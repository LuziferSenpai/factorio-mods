local modName = "__Electronic_Locomotives__"
local meld = require("__core__.lualib.meld")
local firstNamePart = "electronic-provider-"
local providerEntity = data.raw["electric-energy-interface"]["electric-energy-interface"]
local providerItem = data.raw.item.accumulator
local providerRecipe = data.raw.recipe.accumulator

---@type table<int, { bufferCapacity : string, inputRate : string, ingredients : table<int, data.IngredientPrototype[]> }>
local tiers = {
    {
        bufferCapacity = "200MJ",
        inputRate = "5MW",
        ingredients = {
            { type = "item", name = "battery", amount = 10 },
            { type = "item", name = "electronic-circuit", amount = 20 },
            { type = "item", name = "copper-cable", amount = 10 }
        }
    },
    {
        bufferCapacity = "1GJ",
        inputRate = "25MW",
        ingredients = {
            { type = "item", name = "battery", amount = 30 },
            { type = "item", name = "advanced-circuit", amount = 10 },
            { type = "item", name = "copper-cable", amount = 20 }
        }
    },
    {
        bufferCapacity = "5GJ",
        inputRate = "100MW",
        ingredients = {
            { type = "item", name = "battery", amount = 50 },
            { type = "item", name = "processing-unit", amount = 15 },
            { type = "item", name = "copper-cable", amount = 30 }
        }
    },
    {
        bufferCapacity = "20GJ",
        inputRate = "350MW",
        ingredients = {
            { type = "item", name = "battery", amount = 80 },
            { type = "item", name = "processing-unit", amount = 20 },
            { type = "item", name = "copper-cable", amount = 40 },
            { type = "item", name = "low-density-structure", amount = 10 }
        }
    }
}

for i = 1, #tiers do
    local name = firstNamePart .. i
    local electronicData = tiers[i]

    table.insert(electronicData.ingredients, 1, { type = "item", name = (i == 1) and "accumulator" or firstNamePart .. (i - 1), amount = 3 })

    data:extend({
        meld(table.deepcopy(providerEntity), {
            name = name,
            icon = modName .. "/graphics/electronic-standard-provider-icon.png",
            icon_size = 32,
            subgroup = meld.delete(),
            minable = { result = name },
            enable_gui = false,
            gui_mode = "none",
            allow_copy_paste = false,
            energy_source = meld.overwrite({
                type = "electric",
                buffer_capacity = electronicData.bufferCapacity,
                usage_priority = "primary-input",
                input_flow_limit = electronicData.inputRate,
                output_flow_limit = "0MW"
            }),
            energy_production = "0kW",
            energy_usage = "0kW",
            picture = meld.overwrite({
                filename = modName .. "/graphics/electronic-standard-provider-entity.png",
                priority = "extra-high",
                width = 124,
                height = 103,
                shift = { 0.6875, -0.203125 }
            }),
            charge_animation = meld.overwrite({
                filename = modName .. "/graphics/electronic-standard-provider-charge.png",
                width = 138,
                height = 135,
                line_length = 8,
                frame_count = 24,
                shift = { 0.46875, -0.640625 },
                animation_speed = 0.5
            }),
            discharge_animation = meld.overwrite({
                filename = modName .. "/graphics/electronic-standard-providerdischarge.png",
                width = 147,
                height = 128,
                line_length = 8,
                frame_count = 24,
                shift = { 0.390625, -0.53125 },
                animation_speed = 0.5
            }),
            fast_replaceable_group = "electronic-provider",
            next_upgrade = i < #tiers and firstNamePart .. (i + 1) or nil,
            localised_description = { "electronic-locomotives.provider-description" },
            is_electronic = true
        }),
        meld(table.deepcopy(providerItem), {
            name = name,
            icon = modName .. "/graphics/electronic-standard-provider-icon.png",
            icon_size = 32,
            order = "e[accumulator]-aa[" .. name .. "]",
            place_result = name
        }),
        meld(table.deepcopy(providerRecipe), {
            name = name,
            ingredients = meld.overwrite(electronicData.ingredients),
            results = { { name = name } }
        })
    })
end