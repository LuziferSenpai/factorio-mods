local meld = require("__core__/lualib/meld")

--- @alias MoreCasting.CastingFluid "moltenCopper" | "moltenIron"
--- @alias MoreCasting.CastableIngredientsTable table<data.ItemID, uint>

--- @type table<data.ItemID, boolean>
local banList = {
    ["pipe"] = true,
    ["pipe-to-ground"] = true,
    ["iron-plate"] = true,
    ["copper-plate"] = true,
    ["steel-plate"] = true,
    ["iron-gear-wheel"] = true,
    ["iron-stick"] = true,
    ["low-density-structure"] = true,
    ["concrete"] = true,
    ["copper-cable"] = true
}

--- @type table<string, MoreCasting.CastableIngredientsTable>
local castingIngredients = {
    moltenIron = {
        ["iron-plate"] = 10,      --10, 5
        ["steel-plate"] = 30,     --30, 20
        ["iron-gear-wheel"] = 30, --10, 5
        ["iron-stick"] = 5,       --5, 2.5
        ["pipe"] = 10             --10, 5
    },
    moltenCopper = {
        ["copper-plate"] = 10, --10, 5
        ["copper-cable"] = 2.5 --2.5, 1.25
    }
}

--- @type string[]
local itemRaws = {
    "item",
    "item-with-entity-data",
    "rail-planner",
    "repair-tool",
    "ammo",
    "space-platform-starter-pack",
    "capsule",
    "armor",
    "tool"
}

MoreCasting = MoreCasting or {
    banList = banList,
    castingIngredients = castingIngredients,
    itemRaws = itemRaws
}

--- Mark all provided items as banned
--- @param bannedItems data.ItemID[]
function MoreCasting.ban(bannedItems)
    for _, item in pairs(bannedItems) do
        banList[item] = true
    end
end

--- Allow provided items to be replaced with a casting fluid in recipes
--- @param castingFluid MoreCasting.CastingFluid
--- @param ingredients MoreCasting.CastableIngredientsTable
function MoreCasting.add_castable_ingredients(castingFluid, ingredients)
    meld(castingIngredients[castingFluid] or {}, ingredients)
end
