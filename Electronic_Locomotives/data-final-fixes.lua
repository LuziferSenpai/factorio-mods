local locomotives = data.raw.locomotive
local providers = data.raw["electric-energy-interface"]
local locomotiveList = {}
local providerList = {}

data:extend {
    {
        type = "selection-tool",
        name = "electronic-locomotive-list",
        icon = "__flib__/graphics/empty.png",
        icon_size = 1,
        stack_size = 1,
        hidden = true,
        hidden_in_factoriopedia = true,
        select = {
            border_color = {},
            cursor_box_type = "entity",
            mode = "any-entity",
            entity_filters = locomotiveList,
        },
        alt_select = {
            border_color = {},
            cursor_box_type = "entity",
            mode = "any-entity",
            entity_filters = locomotiveList,
        }
    },
    {
        type = "selection-tool",
        name = "electronic-provider-list",
        icon = "__flib__/graphics/empty.png",
        icon_size = 1,
        stack_size = 1,
        hidden = true,
        hidden_in_factoriopedia = true,
        select = {
            border_color = {},
            cursor_box_type = "entity",
            mode = "any-entity",
            entity_filters = providerList,
        },
        alt_select = {
            border_color = {},
            cursor_box_type = "entity",
            mode = "any-entity",
            entity_filters = providerList,
        }
    }
}

for _, locomotive in pairs(locomotives) do
    if locomotive.is_electronic then
        table.insert(locomotiveList, locomotive.name)

        locomotive.energy_source = {
            type = "burner",
            fuel_categories = { "electronic" },
            effectivity = 1,
            fuel_inventory_size = 1
        }
    end
end

for _, provider in pairs(providers) do
    if provider.is_electronic then
        table.insert(providerList, provider.name)
    end
end

-- if data.raw["cargo-wagon"]["cargo-wagon"].max_speed < 3 then
--     data.raw["cargo-wagon"]["cargo-wagon"].max_speed = 3
-- end

-- if data.raw["fluid-wagon"]["fluid-wagon"].max_speed < 3 then
--     data.raw["fluid-wagon"]["fluid-wagon"].max_speed = 3
-- end
