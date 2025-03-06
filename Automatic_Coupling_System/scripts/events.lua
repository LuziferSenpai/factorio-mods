---@type SignalID
local coupleSignalId = { type = "virtual", name = "signal-couple" }
---@type SignalID
local decoupleSignalId = { type = "virtual", name = "signal-decouple" }
local railDirectionDefine = defines.rail_direction
local wireConnectorIdDefine = defines.wire_connector_id
local waitStationDefine = defines.train_state.wait_station
local eventsDefine = defines.events
local eventsLib = {}

---@param entity LuaEntity
---@param signalId SignalID
---@return boolean
local function checkCircuitNetworkHasSignal(entity, signalId)
    local redCircuitNetwork = entity.get_circuit_network(wireConnectorIdDefine.circuit_red)
    local greenCircuitNetwork = entity.get_circuit_network(wireConnectorIdDefine.circuit_green)

    if redCircuitNetwork then
        if redCircuitNetwork.get_signal(signalId) ~= 0 then
            return true
        end
    end

    if greenCircuitNetwork then
        if greenCircuitNetwork.get_signal(signalId) ~= 0 then
            return true
        end
    end

    return false
end

---@param train LuaTrain
---@return boolean
local function checkCircuitNetworkHasSignals(train)
    local stationEntity = train.station

    if stationEntity ~= nil then
        if checkCircuitNetworkHasSignal(stationEntity, coupleSignalId) or checkCircuitNetworkHasSignal(stationEntity, decoupleSignalId) then
            return true
        end
    end

    return false
end

---@param entity LuaEntity
---@param signalId SignalID
---@return number
local function getCircuitNetworkSingalValue(entity, signalId)
    local redCircuitNetwork = entity.get_circuit_network(wireConnectorIdDefine.circuit_red)
    local greenCircuitNetwork = entity.get_circuit_network(wireConnectorIdDefine.circuit_green)
    local signalValue = 0

    if redCircuitNetwork then
        signalValue = signalValue + redCircuitNetwork.get_signal(signalId)
    end

    if greenCircuitNetwork then
        signalValue = signalValue + greenCircuitNetwork.get_signal(signalId)
    end

    return signalValue
end

---comment
---@param entityAOrientation number
---@param entityBOrientation number
local function matchEntityOrientation(entityAOrientation, entityBOrientation)
    return math.abs(entityAOrientation - entityBOrientation) < 0.25 or math.abs(entityAOrientation - entityBOrientation) > 0.75
end

---@param entityAPosition MapPosition
---@param entityBPosition MapPosition
---@return number
local function getOrienationBetweenTwoPositions(entityAPosition, entityBPosition)
    return (math.atan2(entityBPosition.y - entityAPosition.y, entityBPosition.x - entityAPosition.x) / 2 / math.pi + 0.25) % 1
end

---@param positionA MapPosition
---@param positionB MapPosition
---@return number
local function getTileDistanceBetweenTwoPositions(positionA, positionB)
    return math.abs(positionA.x - positionB.x) + math.abs(positionA.y - positionB.y)
end

---@param train LuaTrain
---@param stationEntity LuaEntity
local function getFrontBackTrainEntity(train, stationEntity)
    local trainFrontEntity = train.front_stock
    local trainBackEntity = train.back_stock

    if not (trainFrontEntity and trainBackEntity) then return nil, nil end

    if getTileDistanceBetweenTwoPositions(trainFrontEntity.position, stationEntity.position) < getTileDistanceBetweenTwoPositions(trainBackEntity.position, stationEntity.position) then
        return trainFrontEntity, trainBackEntity
    else
        return trainBackEntity, trainFrontEntity
    end
end

---@param railDirection defines.rail_direction
---@return defines.rail_direction
local function swapRailDirection(railDirection)
    return railDirection == railDirectionDefine.front and railDirectionDefine.back or railDirectionDefine.front
end

---@param train LuaTrain
---@param stationEntity LuaEntity
---@param trainFrontEntity LuaEntity
---@return LuaEntity | nil, LuaEntity | nil
local function attemptUncoupleTrain(train, stationEntity, trainFrontEntity)
    local decoupleCount = getCircuitNetworkSingalValue(stationEntity, decoupleSignalId)
    local carriages = train.carriages

    if decoupleCount ~= 0 then
        if math.abs(decoupleCount) < #carriages then
            ---@type defines.rail_direction
            local decoupleDirection = railDirectionDefine.front
            local targetCount = decoupleCount
            local decoupleCarriage

            if trainFrontEntity ~= train.front_stock then
                decoupleCount = decoupleCount * -1
                targetCount = decoupleCount
            end

            if decoupleCount < 0 then
                decoupleCount = decoupleCount + #carriages
                targetCount = decoupleCount + 1
            else
                decoupleCount = decoupleCount + 1
            end

            decoupleCarriage = carriages[decoupleCount]

            if not matchEntityOrientation(getOrienationBetweenTwoPositions(decoupleCarriage.position, carriages[targetCount].position), decoupleCarriage.orientation) then
                decoupleDirection = swapRailDirection(decoupleDirection)
            end

            if decoupleCarriage.disconnect_rolling_stock(decoupleDirection) then
                return decoupleCarriage, carriages[targetCount]
            end
        end
    end

    return nil, nil
end

---@param stationEntity LuaEntity
---@param trainFrontEntity LuaEntity
---@return boolean
local function attemptCoupleTrain(stationEntity, trainFrontEntity)
    local coupleCount = getCircuitNetworkSingalValue(stationEntity, coupleSignalId)

    if coupleCount ~= 0 then
        ---@type defines.rail_direction
        local coupleRailDirection = coupleCount < 0 and railDirectionDefine.back or railDirectionDefine.front

        if not matchEntityOrientation(trainFrontEntity.orientation, stationEntity.orientation) then
            coupleRailDirection = swapRailDirection(coupleRailDirection)
        end

        if trainFrontEntity.connect_rolling_stock(coupleRailDirection) then
            return true
        end
    end

    return false
end

---@param train LuaTrain
local function doTrainCoupleLogic(train)
    local trainIdString = tostring(train.id)
    local storageTainData = storage.automaticTrainIds[trainIdString]
    local stationEntity = storageTainData.station

    storage.automaticTrainIds[trainIdString] = nil

    if stationEntity and stationEntity.valid then
        local trainFrontEntity, trainBackEntity = getFrontBackTrainEntity(train, stationEntity)

        if not (trainFrontEntity and trainBackEntity) then return end

        local trainSchedule = train.get_schedule()
        local trainGroup = trainSchedule.group
        local scheduleRecords = trainSchedule.get_records()
        local scheduleInterrupts = trainSchedule.get_interrupts()
        local scheduleCurrent = trainSchedule.current
        local didDecouple = false

        trainSchedule.set_stopped(true)
        trainSchedule.clear_records()
        trainSchedule.clear_interrupts()
        trainSchedule.group = ""

        if attemptCoupleTrain(stationEntity, trainFrontEntity) then
            train = trainFrontEntity.train

            if train then
                trainSchedule = train.get_schedule()

                if (trainFrontEntity == train.front_stock or trainBackEntity == train.back_stock) then
                    trainFrontEntity = train.front_stock
                    trainBackEntity = train.back_stock
                else
                    trainFrontEntity = train.back_stock
                    trainBackEntity = train.front_stock
                end
            end
        end

        if train and trainFrontEntity and trainBackEntity then
            local decoupleCarriage, targetCarriage = attemptUncoupleTrain(train, stationEntity, trainFrontEntity)

            if decoupleCarriage and targetCarriage then
                local decoupleCarriageTrain = decoupleCarriage.train
                local targetCarriageTrain = targetCarriage.train

                if decoupleCarriageTrain then
                    if decoupleCarriageTrain.locomotives and (#decoupleCarriageTrain.locomotives.front_movers > 0 or #decoupleCarriageTrain.locomotives.back_movers > 0) then
                        local decoupleCarriageTrainSchedule = decoupleCarriageTrain.get_schedule()

                        if decoupleCarriageTrainSchedule then
                            if trainGroup and #trainGroup > 0 then decoupleCarriageTrainSchedule.group = trainGroup end
                            if scheduleRecords and #scheduleRecords > 0 then decoupleCarriageTrainSchedule.set_records(scheduleRecords) end
                            if scheduleInterrupts and #scheduleInterrupts > 0 then decoupleCarriageTrainSchedule.set_interrupts(scheduleInterrupts) end
                            if scheduleCurrent then decoupleCarriageTrainSchedule.go_to_station(scheduleCurrent) end

                            decoupleCarriageTrainSchedule.set_stopped(false)
                        end
                    end
                end

                if targetCarriageTrain then
                    if targetCarriageTrain.locomotives and (#targetCarriageTrain.locomotives.front_movers > 0 or #targetCarriageTrain.locomotives.back_movers > 0) then
                        local targetCarriageTrainSchedule = targetCarriageTrain.get_schedule()

                        if targetCarriageTrainSchedule then
                            if trainGroup and #trainGroup > 0 then targetCarriageTrainSchedule.group = trainGroup end
                            if scheduleRecords and #scheduleRecords > 0 then targetCarriageTrainSchedule.set_records(scheduleRecords) end
                            if scheduleInterrupts and #scheduleInterrupts > 0 then targetCarriageTrainSchedule.set_interrupts(scheduleInterrupts) end
                            if scheduleCurrent then targetCarriageTrainSchedule.go_to_station(scheduleCurrent) end

                            targetCarriageTrainSchedule.set_stopped(false)
                        end
                    end
                end

                didDecouple = true
            end
        end

        if not didDecouple then
            if trainGroup and #trainGroup > 0 then trainSchedule.group = trainGroup end
            if scheduleRecords and #scheduleRecords > 0 then trainSchedule.set_records(scheduleRecords) end
            if scheduleInterrupts and #scheduleInterrupts > 0 then trainSchedule.set_interrupts(scheduleInterrupts) end
            if scheduleCurrent then trainSchedule.go_to_station(scheduleCurrent) end

            trainSchedule.set_stopped(false)
        end
    end
end

eventsLib.events = {
    [eventsDefine.on_game_created_from_scenario] = function()
        storage.automaticTrainIds = storage.automaticTrainIds or {}
    end,
    ---@param eventData EventData.on_train_created
    [eventsDefine.on_train_created] = function(eventData)
        local newTrainId = tostring(eventData.train.id)
        local oldTrainId1 = tostring(eventData.old_train_id_1)
        local oldTrainId2 = tostring(eventData.old_train_id_2)

        if storage.automaticTrainIds[oldTrainId1] then
            storage.automaticTrainIds[newTrainId] = storage.automaticTrainIds[oldTrainId1]
        elseif storage.automaticTrainIds[oldTrainId2] then
            storage.automaticTrainIds[newTrainId] = storage.automaticTrainIds[oldTrainId2]
        end

        if storage.automaticTrainIds[oldTrainId1] then
            storage.automaticTrainIds[oldTrainId1] = nil
        end

        if storage.automaticTrainIds[oldTrainId2] then
            storage.automaticTrainIds[oldTrainId2] = nil
        end
    end,
    ---@param eventData EventData.on_train_changed_state
    [eventsDefine.on_train_changed_state] = function(eventData)
        local train = eventData.train

        if train.state == waitStationDefine then
            if checkCircuitNetworkHasSignals(train) then
                storage.automaticTrainIds[tostring(train.id)] = { station = train.station }
            end

            return
        end

        if eventData.old_state == waitStationDefine then
            local storageTainData = storage.automaticTrainIds[tostring(train.id)]

            if storageTainData then
                doTrainCoupleLogic(train)
            end
        end
    end
}

eventsLib.on_init = function()
    ---@type table<string, { station: LuaEntity }>
    storage.automaticTrainIds = storage.automaticTrainIds or {}
end

return eventsLib
