local quene = require("scripts.quene")
local flibMath = require("__flib__.math")
local flibTable = require("__flib__.table")
local flibArray = require("__flib__.array")
local trainStateDefine = defines.train_state
local fuelValue = 10000000
local eventsLib = {}
local queneMetatable = { __index = quene }
local isQualityEnabled = false

---@param force LuaForce
---@return string
local function getFuel(force)
    local technologies = force.technologies
    local fuel = "electronic-fuel-1"

    for techName, fuelName in pairs(storage.fuelLookup) do
        if technologies[techName] and technologies[techName].researched then fuel = fuelName end
    end

    return fuel
end

---@param unitNumberString string
local function removeFromQuene(unitNumberString)
    local gameTick = storage.locomotives[unitNumberString]

    storage.updateQuene:remove(gameTick, unitNumberString)
    storage.locomotives[unitNumberString] = nil
end

---@param eventData EventData.on_built_entity | EventData.on_entity_cloned | EventData.on_robot_built_entity | EventData.script_raised_built | EventData.script_raised_revive | { entity: LuaEntity }
local function onEntityCreated(eventData)
    local entity = eventData.entity or eventData.destination
    
    if not (entity and entity.valid) then return end

    local surface = entity.surface

    if not surface.planet then return end

    local entityName = entity.name
    local unitNumberString = tostring(entity.unit_number)
    local gameTick = game.tick + 1

    if storage.locomotiveLookup[entityName] then
        storage.updateQuene:add(entity, gameTick, unitNumberString, tostring(surface.index), tostring(entity.force_index))
        storage.locomotives[unitNumberString] = gameTick
    elseif storage.providerLookup[entityName] then
        storage.providers[tostring(entity.force_index)][tostring(surface.index)][unitNumberString] = entity
    end
end

---@param eventData EventData.on_surface_created | EventData.on_surface_imported
local function onSurfaceCreated(eventData)
    local surface = game.surfaces[eventData.surface_index]

    if surface.planet then
        local surfaceIndexString = tostring(eventData.surface_index)

        for _, providerForce in pairs(storage.providers) do
            providerForce[surfaceIndexString] = {}
        end
    end
end

---@class GlobalTable
---@field fuel table<string, string>
---@field updateQuene Quene
---@field locomotives table<string, int>
---@field providers table<string, table<string, table<string, LuaEntity>>>
---@field locomotiveLookup table<string, int>
---@field providerLookup table<string, boolean>
---@field fuelLookup table<string, string>

local function initGlobals()
    ---@type electronic-locomotives.prototype_name_list
    local electronicModData = prototypes.mod_data["electronic-list"]
    local electronicData = electronicModData.data
    local locomotiveList = electronicData.locomotiveList
    local providerList = electronicData.providerList
    local fuelList = electronicData.fuelList
    local nameFilter = {}

    storage.fuel = storage.fuel or {}
    storage.updateQuene = storage.updateQuene or {}
    storage.locomotives = storage.locomotives or {}
    storage.providers = storage.providers or {}
    storage.locomotiveLookup = {}
    storage.providerLookup = {}
    storage.fuelLookup = {}

    if script.active_mods["quality"] then isQualityEnabled = true end

    setmetatable(storage.updateQuene, queneMetatable)

    if locomotiveList then
        for _, locomotiveName in pairs(locomotiveList) do
            local locomotive = prototypes.entity[locomotiveName]

            storage.locomotiveLookup[locomotiveName] = flibMath.round(locomotive.get_max_energy_usage() / 16.6666666667, 0)

            table.insert(nameFilter, locomotiveName)
        end
    end

    if providerList then
        for _, providerName in pairs(providerList) do
            storage.providerLookup[providerName] = true

            table.insert(nameFilter, providerName)
        end
    end

    if fuelList then
        for fuelNumber, techNumber in pairs(fuelList) do
            storage.fuelLookup["electronic-locomotives-" .. techNumber] = "electronic-fuel-" .. (fuelNumber + 1)
        end
    end

    for _, force in pairs(game.forces) do
        local forceIndexString = tostring(force.index)

        storage.fuel[forceIndexString] = getFuel(force)
        storage.providers[forceIndexString] = storage.providers[forceIndexString] or {}
    end

    for _, planet in pairs(game.planets) do
        local surface = planet.surface

        if surface then
            local surfaceIndexString = tostring(surface.index)
            local entities = surface.find_entities_filtered({ name = nameFilter })

            for _, providerForce in pairs(storage.providers) do
                providerForce[surfaceIndexString] = providerForce[surfaceIndexString] or {}
            end

            if next(entities) then
                for _, entity in pairs(entities) do
                    if entity.type == "locomotive" and not storage.locomotives[tostring(entity.unit_number)] then
                        onEntityCreated({ entity = entity })
                    elseif entity.type == "electric-energy-interface" and not storage.providers[tostring(entity.force_index)][tostring(entity.surface.index)][tostring(entity.unit_number)] then
                        onEntityCreated({ entity = entity })
                    end
                end
            end
        end
    end
end

eventsLib.events = {
    ["on_built_entity"] = onEntityCreated,
    ["on_entity_cloned"] = onEntityCreated,
    ["on_robot_built_entity"] = onEntityCreated,
    ["script_raised_built"] = onEntityCreated,
    ["script_raised_revive"] = onEntityCreated,
    ["on_surface_created"] = onSurfaceCreated,
    ["on_surface_imported"] = onSurfaceCreated,
    ["on_surface_deleted"] = function(eventData)
        local surfaceIndexString = tostring(eventData.surface_index)

        for _, providerForce in pairs(storage.providers) do
            providerForce[surfaceIndexString] = nil
        end
    end,
    ["on_force_created"] = function(eventData)
        local force = eventData.force
        local forceIndexString = tostring(force.index)

        storage.fuel[forceIndexString] = getFuel(force)
        storage.providers[forceIndexString] = storage.providers[forceIndexString] or {}

        for _, planet in pairs(game.planets) do
            local surface = planet.surface

            if surface then
                storage.providers[forceIndexString][tostring(surface.index)] = {}
            end
        end
    end,
    ["on_forces_merged"] = function(eventData)
        local destinationForce = eventData.destination
        local sourceForceIndexString = tostring(eventData.source_index)
        local destinationForceIndexString = tostring(destinationForce.index)

        storage.fuel[destinationForceIndexString] = getFuel(destinationForce)

        for _, planet in pairs(game.planets) do
            local surface = planet.surface

            if surface then
                local surfaceIndexString = tostring(surface.index)

                storage.providers[destinationForceIndexString][surfaceIndexString] = flibTable.deep_merge(storage.providers[sourceForceIndexString][surfaceIndexString], storage.providers[destinationForceIndexString][surfaceIndexString])
            end
        end
    end,
    ["on_research_finished"] = function(eventData)
        local research = eventData.research
        local lookedUpFuel = storage.fuelLookup[research.name]

        if lookedUpFuel then storage.fuel[tostring(research.force.index)] = lookedUpFuel end
    end,
    ["on_train_changed_state"] = function(eventData)
        local train = eventData.train
        local trainState = train.state

        if (trainState == trainStateDefine.wait_signal or trainState == trainStateDefine.wait_station) then return end

        local locomotiveLookup = storage.locomotiveLookup
        local locomotives = flibArray.flatten({ train.locomotives.front_movers, train.locomotives.back_movers })
        local locomotiveUpdateList = {}

        for _, locomotive in pairs(locomotives) do
            if locomotiveLookup[locomotive.name] then
                locomotiveUpdateList[tostring(locomotive.unit_number)] = locomotive
            end
        end

        if not next(locomotiveUpdateList) then return end

        if ((trainState == trainStateDefine.arrive_signal or trainState == trainStateDefine.arrive_station) or (train.speed == 0 and trainState ~= trainStateDefine.on_the_path)) then
            for unitNumberString, _ in pairs(locomotiveUpdateList) do
                if storage.locomotives[unitNumberString] then removeFromQuene(unitNumberString) end
            end
        else
            local gameTick = game.tick

            for unitNumberString, locomotive in pairs(locomotiveUpdateList) do
                if storage.locomotives[unitNumberString] then removeFromQuene(unitNumberString) end

                local burner = locomotive.burner
                local fuelTick = math.floor(burner.remaining_burning_fuel / burner.heat_capacity)
                local nextFuelTick = gameTick + (fuelTick > 0 and fuelTick or 1)

                storage.updateQuene:add(locomotive, nextFuelTick, unitNumberString, tostring(locomotive.surface.index), tostring(locomotive.force_index))
                storage.locomotives[unitNumberString] = nextFuelTick
            end
        end
    end,
    ["on_tick"] = function(eventData)
        if not next(storage.locomotives) then return end

        local gameTick = eventData.tick
        local updateQuene = storage.updateQuene[gameTick]

        storage.updateQuene[gameTick] = nil

        if not (updateQuene and next(updateQuene)) then return end

        local allProviders = storage.providers
        local allFuels = storage.fuel
        ---@type LuaEntity, string, string, table<string, LuaEntity>, LuaBurner, number, number
        local locomotive, surfaceIndexString, forceIndexString, providers, burner, missingFuel, newFuelAmount
        local gameTickPlusOne = gameTick + 1
        local nextFuelTick = gameTickPlusOne

        for locomotiveUnitNumberString, locomotiveTable in pairs(updateQuene) do
            locomotive = locomotiveTable.entity

            if locomotive.valid then
                surfaceIndexString = locomotiveTable.surfaceIndexString
                forceIndexString = locomotiveTable.forceIndexString
                providers = allProviders[forceIndexString][surfaceIndexString]

                if next(providers) then
                    burner = locomotive.burner
                    missingFuel = fuelValue - burner.remaining_burning_fuel
                    newFuelAmount = missingFuel
                    nextFuelTick = gameTick + 1

                    for providerUnitNumberString, provider in pairs(providers) do
                        if provider.valid then
                            local energy = provider.energy

                            if energy >= newFuelAmount then
                                provider.energy = energy - newFuelAmount

                                newFuelAmount = 0

                                break
                            else
                                newFuelAmount = newFuelAmount - energy

                                provider.energy = 0
                            end
                        else
                            storage.providers[forceIndexString][surfaceIndexString][providerUnitNumberString] = nil
                        end
                    end

                    if newFuelAmount < missingFuel then
                        local remainingBurningFuel = fuelValue - newFuelAmount
                        local fuelTick = math.floor(remainingBurningFuel / burner.heat_capacity)

                        nextFuelTick = gameTick + (fuelTick > 0 and fuelTick or 1)

                        burner.currently_burning = isQualityEnabled and allFuels[forceIndexString] or {name = allFuels[forceIndexString], quality = locomotive.quality }
                        burner.remaining_burning_fuel = remainingBurningFuel
                    end
                end

                if locomotive.speed == 0 and locomotive.train.state == trainStateDefine.manual_control and nextFuelTick > gameTickPlusOne then
                    storage.locomotives[locomotiveUnitNumberString] = nil
                else
                    storage.updateQuene:add(locomotive, nextFuelTick, locomotiveUnitNumberString, surfaceIndexString, forceIndexString)
                    storage.locomotives[locomotiveUnitNumberString] = nextFuelTick
                end
            else
                storage.locomotives[locomotiveUnitNumberString] = nil
            end
        end
    end
}

eventsLib.on_init = function()
    initGlobals()
end

eventsLib.on_load = function()
    if storage.updateQuene then
        setmetatable(storage.updateQuene, queneMetatable)
    end
end

eventsLib.on_configuration_changed = function(eventData)
    local electronicChanges = eventData.mod_changes and eventData.mod_changes["Electronic_Locomotives"] or {}

    initGlobals()

    if not next(electronicChanges) then return end

    local electronicOldVersion = electronicChanges.old_version

    if not (electronicOldVersion and electronicChanges.new_version) then return end

    if electronicOldVersion < "3.1.1" and electronicOldVersion >= "3.0.0" then
        if next(storage.updateQuene) then
            local newQuene = {}

            for gameTick, locomotives in pairs(storage.updateQuene) do
                for unitNumberString, locomotiveData in pairs(locomotives) do
                    if locomotiveData.valid then
                        newQuene[unitNumberString] = { entity = locomotiveData, gameTick = gameTick }

                        removeFromQuene(unitNumberString)
                    end
                end
            end

            for unitNumberString, locomotiveData in pairs(newQuene) do
                local entity = locomotiveData.entity

                storage.updateQuene:add(entity, locomotiveData.gameTick, unitNumberString, tostring(entity.surface.index), tostring(entity.force_index))
                storage.locomotives[unitNumberString] = locomotiveData.gameTick
            end
        end
    end

    if electronicOldVersion == "3.1.1" then
        if next(storage.updateQuene) then
            local newQuene = {}

            for gameTick, locomotives in pairs(storage.updateQuene) do
                for unitNumberString, locomotiveData in pairs(locomotives) do
                    if locomotiveData.valid then
                        newQuene[unitNumberString] = { entity = locomotiveData, gameTick = gameTick }

                        removeFromQuene(unitNumberString)
                    end
                end
            end

            for unitNumberString, locomotiveData in pairs(newQuene) do
                local entity = locomotiveData.entity

                storage.updateQuene:add(entity, locomotiveData.gameTick, unitNumberString, tostring(entity.surface.index), tostring(entity.force_index))
                storage.locomotives[unitNumberString] = locomotiveData.gameTick
            end
        end
    end
end

return eventsLib
