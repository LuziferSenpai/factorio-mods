local flibFormat = require("__flib__/format")
local flibGui = require("__flib__/gui")
local flibPosition = require("__flib__/position")
local modGui = require("__core__/lualib/mod-gui")
local eventsDefine = defines.events
local guiPosition = { x = 15, y = 58 + 15 }
local logGui = {}

local function toggleMainGui(event)
    local globalPlayer = storage.players[tostring(event.player_index)]
    local logGuiMain = globalPlayer.guis.logGuiMain

    if logGuiMain and logGuiMain.valid then
        if logGuiMain.visible then
            logGuiMain.visible = false
        else
            logGuiMain.visible = true
        end
    else
        logGui.buildMainGui(globalPlayer, game.players[event.player_index])
    end
end

local function changeSelectedPlatform(event)
    local globalPlayer = storage.players[tostring(event.player_index)]
    local playerForceIndex = tostring(game.players[event.player_index].force_index)
    local selectedIndex = event.element.selected_index

    globalPlayer.selectedIndex = selectedIndex

    logGui.buildLogGui(globalPlayer, storage.platforms[playerForceIndex][storage.platformsList[playerForceIndex][selectedIndex]].entries)
end

local function changeSortingDirection(event)
    local globalPlayer = storage.players[tostring(event.player_index)]
    local playerForceIndex = tostring(game.players[event.player_index].force_index)

    globalPlayer.reverserSortingDirection = not globalPlayer.reverserSortingDirection

    logGui.buildLogGui(globalPlayer, storage.platforms[playerForceIndex][storage.platformsList[playerForceIndex][globalPlayer.selectedIndex]].entries)
end

function logGui.buildGuiButton(globalPlayer, player)
    local logGuiButton = globalPlayer.guis.logGuiButton

    if not logGuiButton or not logGuiButton.valid then
        local elems = flibGui.add(modGui.get_button_flow(player), {
            type = "sprite-button",
            name = "logGuiButton",
            sprite = "log-button-icon",
            style = modGui.button_style,
            handler = { [eventsDefine.on_gui_click] = toggleMainGui }
        })

        globalPlayer.guis.logGuiButton = elems.logGuiButton
    end
end

function logGui.buildMainGui(globalPlayer, player)
    local logGuiMain = globalPlayer.guis.logGuiMain

    if not logGuiMain or not logGuiMain.valid then
        local playerForceIndex = tostring(player.force_index)
        local scale = player.display_scale
        local elems = flibGui.add(player.gui.screen, {
            type = "frame",
            name = "logGuiMain",
            direction = "vertical",
            {
                type = "flow",
                style = "flib_titlebar_flow",
                drag_target = "logGuiMain",
                {
                    type = "label",
                    style = "frame_title",
                    caption = { "captains-log.captainsLog" },
                    ignored_by_interaction = true
                },
                {
                    type = "empty-widget",
                    style = "flib_titlebar_drag_handle",
                    ignored_by_interaction = true
                },
                {
                    type = "sprite-button",
                    name = "logCloseButton",
                    style = "frame_action_button",
                    sprite = "utility/close",
                    mouse_button_filter = { "left" },
                    handler = { [eventsDefine.on_gui_click] = toggleMainGui }
                }
            },
            {
                type = "flow",
                direction = "horizontal",
                style_mods = { horizontal_spacing = 8 },
                {
                    type = "list-box",
                    name = "logGuiPlatformListBox",
                    items = storage.platformsListDisplay[playerForceIndex],
                    style_mods = { width = 225, height = 420 },
                    handler = { [eventsDefine.on_gui_selection_state_changed] = changeSelectedPlatform }
                },
                {
                    type = "frame",
                    style = "inside_deep_frame",
                    direction = "vertical",
                    {
                        type = "scroll-pane",
                        name = "logGuiLogScrollPane",
                        style = "flib_naked_scroll_pane_no_padding",
                        style_mods = { width = 350, height = 420, horizontally_stretchable = true, extra_right_padding_when_activated = 0, padding = { 6, 0 } }
                    }
                }
            }
        })

        elems.logGuiMain.location = flibPosition.mul(guiPosition, { scale, scale })
        elems.logGuiPlatformListBox.selected_index = 1

        globalPlayer.guis.logGuiMain = elems.logGuiMain
        globalPlayer.guis.logGuiPlatformListBox = elems.logGuiPlatformListBox
        globalPlayer.guis.logGuiLogScrollPane = elems.logGuiLogScrollPane

        logGui.buildLogGui(globalPlayer, storage.platforms[playerForceIndex][storage.platformsList[playerForceIndex][1]].entries)
    end
end

function logGui.buildLogGui(globalPlayer, platformLogEntries)
    local logGuiLogScrollPane = globalPlayer.guis.logGuiLogScrollPane
    local reverserSortingDirection = globalPlayer.reverserSortingDirection
    local leadingZerosNeeded = math.floor(math.log10(#platformLogEntries)) + 1
    local captions = {
        "#",
        { "captains-log.journey" },
        { "captains-log.loadingTime" },
        { "captains-log.journeyTime" }
    }

    if logGuiLogScrollPane and logGuiLogScrollPane.valid then
        logGuiLogScrollPane.clear()
    else
        globalPlayer.guis.logGuiMain.destroy()

        return
    end

    local logTable = {
        type = "table",
        name = "logTable",
        style = "captains_log_table",
        column_count = 5,
        style_mods = { horizontal_spacing = 12, padding = { 6, 0, 0, 12 } }
    }

    for _, caption in pairs(captions) do
        local captionElement = {
            type = "label",
            caption = caption,
            style = "bold_label",
            style_mods = { bottom_margin = 6 }
        }

        if caption == "#" then
            captionElement.caption = captionElement.caption .. "[img=" .. (reverserSortingDirection and "sort-bottom-top" or "sort-top-bottom") .. "-icon]"
            captionElement.style = "captains_log_bold_clickable_label"
            captionElement.handler = { [eventsDefine.on_gui_click] = changeSortingDirection }
        end

        table.insert(logTable, captionElement)
    end

    table.insert(logTable, {
        type = "empty-widget",
        style = "flib_horizontal_pusher"
    })

    if reverserSortingDirection then
        for i = #platformLogEntries, 1, -1 do
            local entry = platformLogEntries[i]
            local planetString = entry.leavePlanet and "[img=space-location." .. entry.leavePlanet .. "]" or "-"
            local loadingTime = entry.leaveTick - entry.startWaitingTick
            local journeyTime = entry.arriveTick - entry.leaveTick

            if entry.arrivePlanet then
                planetString = planetString .. " → [img=space-location." .. entry.arrivePlanet .. "]"
            end

            table.insert(logTable, {
                type = "label",
                caption = string.format("%0" .. leadingZerosNeeded .. "d", i)
            })
            table.insert(logTable, {
                type = "label",
                caption = planetString
            })
            table.insert(logTable, {
                type = "label",
                caption = loadingTime > 0 and tostring(flibFormat.time(loadingTime, true)) or "-"
            })
            table.insert(logTable, {
                type = "label",
                caption = journeyTime > 0 and tostring(flibFormat.time(journeyTime, true)) or "-"
            })
            table.insert(logTable, {
                type = "empty-widget",
                style = "flib_horizontal_pusher"
            })
        end
    else
        for index, entry in pairs(platformLogEntries) do
            local planetString = entry.leavePlanet and "[img=space-location." .. entry.leavePlanet .. "]" or "-"
            local loadingTime = entry.leaveTick - entry.startWaitingTick
            local journeyTime = entry.arriveTick - entry.leaveTick

            if entry.arrivePlanet then
                planetString = planetString .. " → [img=space-location." .. entry.arrivePlanet .. "]"
            end

            table.insert(logTable, {
                type = "label",
                caption = string.format("%0" .. leadingZerosNeeded .. "d", index)
            })
            table.insert(logTable, {
                type = "label",
                caption = planetString
            })
            table.insert(logTable, {
                type = "label",
                caption = loadingTime > 0 and tostring(flibFormat.time(loadingTime, true)) or "-"
            })
            table.insert(logTable, {
                type = "label",
                caption = journeyTime > 0 and tostring(flibFormat.time(journeyTime, true)) or "-"
            })
            table.insert(logTable, {
                type = "empty-widget",
                style = "flib_horizontal_pusher"
            })
        end
    end

    local elems = flibGui.add(logGuiLogScrollPane, logTable)

    for i = 1, 6 do
        elems.logTable.style.column_alignments[i] = "center"
    end
end

flibGui.add_handlers({
    toggleMainGui = toggleMainGui,
    changeSelectedPlatform = changeSelectedPlatform,
    changeSortingDirection = changeSortingDirection
})

return logGui
