local kanbanGui = require("__tasktorio__/scripts/gui/kanban")
local eventsDefine = defines.events
local eventsLib = {}

local function initPlayer(player)
    local playerIndexString = tostring(player.index)

    if not storage.players[playerIndexString] then
        storage.players[playerIndexString] = {
            guis = {
                tasks = {}
            },
            indexString = playerIndexString,
            forceIndexString = tostring(player.force_index),
            displayResolution = player.display_resolution,
            displayScale = player.display_scale
        }

        kanbanGui.buildGuiButton(storage.players[playerIndexString], player)
    end
end

local function initStorage()
    storage.players = storage.players or {}
    storage.allTasks = storage.allTasks or {}
    storage.forceData = storage.forceData or {}

    for _, force in pairs(game.forces) do
        local forceIndexString = tostring(force.index)

        storage.forceData[forceIndexString] = storage.forceData[forceIndexString] or {
            tasks = {},
            lists = {
                {
                    name = "List 1",
                    tasks = {}
                },
                {
                    name = "List 2",
                    tasks = {}
                },
                {
                    name = "List 3",
                    tasks = {}
                },
                {
                    name = "List 4",
                    tasks = {}
                },
                {
                    name = "List 5",
                    tasks = {}
                },
                {
                    name = "List 6",
                    tasks = {}
                },
                {
                    name = "List 7",
                    tasks = {}
                },
                {
                    name = "List 8",
                    tasks = {}
                },
                {
                    name = "List 9",
                    tasks = {}
                },
                {
                    name = "List 10",
                    tasks = {}
                },
                {
                    name = "List 11",
                    tasks = {}
                }
            },
            labels = {}
        }
    end

    for i = 1, 40 do
        table.insert(storage.allTasks, {
            title = "Task " .. i,
            description = "Description " .. i
        })

        table.insert(storage.forceData["1"].lists[1].tasks, i)
    end
end

eventsLib.events = {
    [eventsDefine.on_player_created] = function(event)
        initPlayer(game.players[event.player_index])
    end,
    [eventsDefine.on_player_display_resolution_changed] = function(event)
        storage.players[tostring(event.player_index)].displayResolution = game.players[event.player_index].display_resolution
    end,
    [eventsDefine.on_player_removed] = function(event)
        if storage.players then
            storage.players[tostring(event.player_index)] = nil
        end
    end,
    [eventsDefine.on_player_display_scale_changed] = function(event)
        storage.players[tostring(event.player_index)].displayScale = game.players[event.player_index].display_scale
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
