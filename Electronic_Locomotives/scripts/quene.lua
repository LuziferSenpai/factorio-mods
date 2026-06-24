---@class QueneEntry
---@field entity LuaEntity
---@field surfaceIndexString string
---@field forceIndexString string

---@class Quene
---@field [int] table<string, QueneEntry>
local quene = {}

---@param entity LuaEntity
---@param gameTick int
---@param unitNumberString string
---@param surfaceIndexString string
---@param forceIndexString string
function quene:add(entity, gameTick, unitNumberString, surfaceIndexString, forceIndexString)
    self[gameTick] = self[gameTick] or {}
    self[gameTick][unitNumberString] = { entity = entity, surfaceIndexString = surfaceIndexString, forceIndexString = forceIndexString }
end

---@param gameTick int
---@param unitNumberString string
function quene:remove(gameTick, unitNumberString)
    self[gameTick][unitNumberString] = nil

    if not next(self[gameTick]) then
        self[gameTick] = nil
    end
end

return quene
