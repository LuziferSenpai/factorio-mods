for _, cargoWagon in pairs(data.raw["cargo-wagon"]) do
    cargoWagon.quality_affects_inventory_size = true
end

for _, fluidWagon in pairs(data.raw["fluid-wagon"]) do
    fluidWagon.quality_affects_capacity = true
end