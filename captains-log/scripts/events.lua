local logGui = require("__captains-log__/scripts/gui")
local spacePlatformStateDefine = defines.space_platform_state
local eventsDefine = defines.events
local eventsLib = {}
local spacePlatformStateDefineToIcon = {
    [spacePlatformStateDefine.waiting_for_starter_pack] = "[img=waiting-icon]",
    [spacePlatformStateDefine.starter_pack_requested] = "[img=requested-icon]",
    [spacePlatformStateDefine.starter_pack_on_the_way] = "[img=on-the-way-icon]",
    [spacePlatformStateDefine.on_the_path] = "[img=on-the-path-icon]",
    [spacePlatformStateDefine.waiting_for_departure] = "[img=waiting-for-departure-icon]",
    [spacePlatformStateDefine.no_schedule] = "[img=no-schedule-icon]",
    [spacePlatformStateDefine.no_path] = "[img=utility/no_path_icon]",
    [spacePlatformStateDefine.waiting_at_station] = "[img=waiting-at-station-icon]",
    [spacePlatformStateDefine.paused] = "[img=pause-icon]"
}

local function initPlayer(player)
    local playerIndexString = tostring(player.index)
    local forceIndexString = tostring(player.force_index)

    if not storage.players[playerIndexString] then
        storage.players[playerIndexString] = {
            selectedIndex = 1,
            guis = {}
        }

        if #storage.platformsList[forceIndexString] > 0 then
            logGui.buildGuiButton(storage.players[playerIndexString], player)
        end
    else
        if storage.players[playerIndexString].guis.logGuiMain then
            storage.players[playerIndexString].guis.logGuiMain.destroy()
        end
    end
end

local function initStorage()
    storage.players = storage.players or {}
    storage.platforms = storage.platforms or {}
    storage.platformsList = storage.platformsList or {}
    storage.platformsListDisplay = storage.platformsListDisplay or {}

    for _, force in pairs(game.forces) do
        local forceIndexString = tostring(force.index)

        storage.platforms[forceIndexString] = storage.platforms[forceIndexString] or {}
        storage.platformsList[forceIndexString] = storage.platformsList[forceIndexString] or {}
        storage.platformsListDisplay[forceIndexString] = storage.platformsListDisplay[forceIndexString] or {}

        for _, platform in pairs(force.platforms) do
            local platformIndexString = tostring(platform.index)

            if not storage.platforms[forceIndexString][platformIndexString] then
                storage.platforms[forceIndexString][platformIndexString] = {
                    name = platform.name,
                    index = #storage.platformsList[forceIndexString] + 1,
                    leaveTick = 0,
                    arriveTick = 0,
                    platform = platform,
                    entries = {},
                    migratedWhileFlying = not platform.space_location
                }

                if platform.space_location then
                    table.insert(storage.platforms[forceIndexString][platformIndexString].entries, {
                        leavePlanet = platform.space_location.name,
                        startWaitingTick = game.tick,
                        arriveTick = 0,
                        leaveTick = 0
                    })

                    storage.platforms[forceIndexString][platformIndexString].arriveTick = game.tick
                end

                table.insert(storage.platformsList[forceIndexString], platformIndexString)
                table.insert(storage.platformsListDisplay[forceIndexString], spacePlatformStateDefineToIcon[platform.state] .. " " .. platform.name)
            end
        end
    end
end

eventsLib.events = {
    [eventsDefine.on_player_created] = function(event)
        initPlayer(game.players[event.player_index])
    end,
    [eventsDefine.on_player_removed] = function(event)
        if storage.players then
            storage.players[tostring(event.player_index)] = nil
        end
    end,
    [eventsDefine.on_space_platform_changed_state] = function(event)
        local platform = event.platform
        local platformForce = platform.force
        local platformState = platform.state
        local spaceLocation = platform.space_location
        local forceIndexString = tostring(platformForce.index)
        local platformIndexString = tostring(platform.index)
        local platforms = storage.platforms[forceIndexString]
        local platformsList = storage.platformsList[forceIndexString]
        local platformsListDisplay = storage.platformsListDisplay[forceIndexString]
        local platformData = platforms[platformIndexString]
        local globalPlayers = storage.players
        local firstPlatform = #storage.platformsList[forceIndexString] == 0
        local gameTick = game.tick

        if not platformData then
            platforms[platformIndexString] = {
                name = platform.name,
                index = #platformsList + 1,
                leaveTick = 0,
                arriveTick = gameTick,
                platform = platform,
                entries = {}
            }

            platformData = platforms[platformIndexString]

            table.insert(platformsList, platformIndexString)
        end

        if platformState == spacePlatformStateDefine.on_the_path then
            if platformData.arriveTick > 0 then
                platformData.entries[#platformData.entries].leaveTick = gameTick
                platformData.leaveTick = gameTick
                platformData.arriveTick = 0
            end
        elseif platformState == spacePlatformStateDefine.waiting_at_station then
            if platformData.leaveTick > 0 then
                platformData.entries[#platformData.entries].arriveTick = gameTick
                platformData.entries[#platformData.entries].arrivePlanet = spaceLocation.name
                platformData.arriveTick = gameTick
                platformData.leaveTick = 0
                platformData.entries[#platformData.entries + 1] = {
                    leavePlanet = spaceLocation.name,
                    startWaitingTick = gameTick,
                    arriveTick = 0,
                    leaveTick = 0
                }
            end

            if platformData.migratedWhileFlying then
                platformData.arriveTick = gameTick
                platformData.leaveTick = 0
                platformData.entries[#platformData.entries + 1] = {
                    leavePlanet = spaceLocation.name,
                    startWaitingTick = gameTick,
                    arriveTick = 0,
                    leaveTick = 0
                }

                platformData.migratedWhileFlying = false
            end
        elseif platformState == spacePlatformStateDefine.paused then
            if event.old_state ~= spacePlatformStateDefine.waiting_at_station and event.old_state ~= spacePlatformStateDefine.on_the_path then
                platformData.entries[#platformData.entries + 1] = {
                    leavePlanet = spaceLocation.name,
                    startWaitingTick = gameTick,
                    arriveTick = 0,
                    leaveTick = 0
                }
            end
        end

        if platformData and platform.name ~= platformData.name then
            platformData.name = platform.name
        end

        platformsListDisplay[platformData.index] = spacePlatformStateDefineToIcon[platformState] .. " " .. platformData.name

        for _, player in pairs(platformForce.players) do
            local playerIndexString = tostring(player.index)
            local globalPlayer = globalPlayers[playerIndexString]
            local globalPlayerGuis = globalPlayer.guis

            if firstPlatform then
                logGui.buildGuiButton(storage.players[playerIndexString], player)
            end

            if globalPlayerGuis.logGuiPlatformListBox and globalPlayerGuis.logGuiPlatformListBox.valid then
                globalPlayerGuis.logGuiPlatformListBox.items = platformsListDisplay
            end

            if globalPlayer.selectedIndex == platformData.index then
                if globalPlayerGuis.logGuiMain then
                    logGui.buildLogGui(globalPlayer, platformData.entries)
                end
            end
        end
    end
}

eventsLib.on_init = function()
    initStorage()

    for _, player in pairs(game.players) do
        initPlayer(player)
    end
end

eventsLib.on_configuration_changed = function()
    initStorage()

    for _, player in pairs(game.players) do
        initPlayer(player)
    end
end

return eventsLib
