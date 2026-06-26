local locomotives = data.raw.locomotive
local providers = data.raw["electric-energy-interface"]
---@type string[]
local locomotiveList = {}
---@type string[]
local providerList = {}

---@class electronic-locomotives.prototype_name_list
---@field data { locomotiveList : string[], providerList : string[], fuelList : int[] }

data:extend({
    {
        type = "mod-data",
        name = "electronic-list",
        data_type = "electronic-locomotives.prototype_name_list",
        data = {
            locomotiveList = locomotiveList,
            providerList = providerList,
            fuelList = { 3, 5, 7, 9 }
        }
    }
})

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
