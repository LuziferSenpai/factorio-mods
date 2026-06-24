local meld = require("__core__.lualib.meld")
local modName = "__Electronic_Locomotives__"
local name = "electronic-heavy-provider"

data:extend({
    meld(table.deepcopy(data.raw["electric-energy-interface"]["electric-energy-interface"]), {
        name = name,
        icon = modName .. "/graphics/" .. name .. "-icon.png",
        icon_size = 32,
        subgroup = meld.delete(),
        minable = { result = name },
        enable_gui = false,
        gui_mode = "none",
        allow_copy_paste = false,
        energy_source = meld.overwrite({
            type = "electric",
            buffer_capacity = "10GJ",
            usage_priority = "primary-input",
            input_flow_limit = "500MW",
            output_flow_limit = "0MW"
        }),
        energy_production = "0kW",
        energy_usage = "0kW",
        picture = meld.overwrite({
            filename = modName .. "/graphics/" .. name .. "-entity.png",
            priority = "extra-high",
            width = 124,
            height = 103,
            shift = { 0.6875, -0.203125 }
        }),
        charge_animation = meld.overwrite({
            filename = modName .. "/graphics/" .. name .. "-charge.png",
            width = 138,
            height = 135,
            line_length = 8,
            frame_count = 24,
            shift = { 0.46875, -0.640625 },
            animation_speed = 0.5
        }),
        discharge_animation = meld.overwrite({
            filename = modName .. "/graphics/" .. name .. "discharge.png",
            width = 147,
            height = 128,
            line_length = 8,
            frame_count = 24,
            shift = { 0.390625, -0.53125 },
            animation_speed = 0.5
        }),
        fast_replaceable_group = "electronic-provider",
        localised_description = { "electronic-locomotives.provider-description" },
        is_electronic = true
    }),
    meld(table.deepcopy(data.raw["item"]["accumulator"]), {
        name = name,
        icon = modName .. "/graphics/" .. name .. "-icon.png",
        icon_size = 32,
        order = "e[accumulator]-ab[" .. name .. "]",
        place_result = name
    }),
    meld(table.deepcopy(data.raw["recipe"]["accumulator"]), {
        name = name,
        ingredients = meld.overwrite({
            { type = "item", name = "electronic-standard-provider", amount = 5 },
            { type = "item", name = "battery", amount = 50 },
            { type = "item", name = "processing-unit", amount = 10 }
        }),
        results = { { name = name } }
    })
})