local meld = require("__core__.lualib.meld")

---@alias MoreCasting.castingFluids "moltenIron" | "moltenCopper"
---@alias MoreCasting.castableIngredients table<data.ItemID, int>

---@class MoreCasting
---@field banList table<data.ItemID, boolean>
---@field castingIngredients table<MoreCasting.castingFluids, MoreCasting.castableIngredients>
---@field banItems fun(self : MoreCasting, bannedItems : data.ItemID[])
---@field addCastableIngredients fun(self : MoreCasting, castingFluid : MoreCasting.castingFluids, ingredients : MoreCasting.castableIngredients)
MoreCasting = MoreCasting or {
    banList = {
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
    },
    castingIngredients = {
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
    },
}

function MoreCasting:banItems(bannedItems)
    for _, item in pairs(bannedItems) do
        self.banList[item] = true
    end
end

function MoreCasting:addCastableIngredients(castingFluid, ingredients)
    if not self.castingIngredients[castingFluid] then return end

    meld(self.castingIngredients[castingFluid], ingredients)
end