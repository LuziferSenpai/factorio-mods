local modGui = require("__core__/lualib/mod-gui")
local flibGui = require("__flib__/gui")
local listGui = require("__tasktorio__/scripts/gui/list")
local lib = require("__tasktorio__/scripts/gui/lib")
local eventsDefine = defines.events
local kanbanGui = {}

local function toggleMainGui(event)
    local globalPlayer = storage.players[tostring(event.player_index)]
    local kanbanGuiMain = globalPlayer.guis.kanbanGuiMain

    if kanbanGuiMain and kanbanGuiMain.valid then
        if kanbanGuiMain.visible then
            kanbanGuiMain.visible = false
        else
            kanbanGuiMain.visible = true
        end
    else
        kanbanGui.buildMainGui(globalPlayer, game.players[event.player_index])
    end
end

local function showAddList(event)
    local element = event.element
    local addListElement = element.parent.children[#element.parent.children]

    element.visible = false

    addListElement.visible = true
    addListElement.children[1].children[1].text = ""
end

local function addList(event)
    local textfieldElement = event.element.parent.children[1]

    if #textfieldElement.text > 0 then
        local listFlowElement = event.element.parent.parent.parent
        local globalPlayer = storage.players[tostring(event.player_index)]
        local lists = storage.forceData[globalPlayer.forceIndexString].lists

        table.insert(lists, {
            name = textfieldElement.text,
            tasks = {}
        })

        listGui.buildListGui(globalPlayer, lists[#lists], #lists, #lists)

        lib.moveChildren(listFlowElement, #listFlowElement.children, #listFlowElement.children - 2)

        listFlowElement.children[#listFlowElement.children].visible = false
        listFlowElement.children[#listFlowElement.children - 1].visible = true
        listFlowElement.parent.scroll_to_right()

        for _, childElement in pairs(listFlowElement.children) do
            if childElement.tags and childElement.tags.forceIndexString then
                local indexInParent = childElement.get_index_in_parent()
                local childFlowElement = childElement.children[1]

                childFlowElement.children[4].enabled = indexInParent ~= 1
                childFlowElement.children[5].enabled = indexInParent ~= #lists
            end
        end
    end
end

local function hideAddList(event)
    local addListElement = event.element.parent.parent

    addListElement.visible = false
    addListElement.parent.children[addListElement.get_index_in_parent() - 1].visible = true
end

function kanbanGui.buildGuiButton(globalPlayer, player)
    local kanbanGuiButton = globalPlayer.guis.kanbanGuiButton

    if not (kanbanGuiButton and kanbanGuiButton.valid) then
        local elems = flibGui.add(modGui.get_button_flow(player), {
            type = "button",
            name = "kanbanGuiButton",
            caption = "Open",
            style = modGui.button_style,
            handler = { [eventsDefine.on_gui_click] = toggleMainGui }
        })

        globalPlayer.guis.kanbanGuiButton = elems.kanbanGuiButton
    end
end

function kanbanGui.buildMainGui(globalPlayer, player)
    local kanbanGuiMain = globalPlayer.guis.kanbanGuiMain

    if not (kanbanGuiMain and kanbanGuiMain.valid) then
        local forceLists = storage.forceData[globalPlayer.forceIndexString].lists
        local playerDisplayResolution = player.display_resolution
        local playerDisplayScale = player.display_scale
        local elems = flibGui.add(player.gui.screen, {
            type = "frame",
            name = "kanbanGuiMain",
            direction = "vertical",
            location = { 0, 0 },
            style_mods = { width = playerDisplayResolution.width / playerDisplayScale, height = playerDisplayResolution.height / playerDisplayScale },
            {
                type = "flow",
                style = "flib_titlebar_flow",
                {
                    type = "label",
                    style = "flib_frame_title",
                    caption = "Tasktorio",
                    ignored_by_interaction = true
                },
                {
                    type = "empty-widget",
                    style = "flib_titlebar_drag_handle",
                    ignored_by_interaction = true
                },
                {
                    type = "sprite-button",
                    name = "taskCloseButton",
                    style = "frame_action_button",
                    sprite = "utility/close",
                    mouse_button_filter = { "left" },
                    handler = { [eventsDefine.on_gui_click] = toggleMainGui }
                }
            },
            {
                type = "frame",
                style = "inside_deep_frame",
                direction = "vertical",
                {
                    type = "scroll-pane",
                    style = "flib_naked_scroll_pane_no_padding",
                    style_mods = {
                        height = (playerDisplayResolution.height - 65) / playerDisplayScale,
                        horizontally_stretchable = true,
                        extra_bottom_padding_when_activated = 0,
                        padding = { 6, 6 }
                    },
                    {
                        type = "flow",
                        name = "kanbanGuiListFlow",
                        direction = "horizontal",
                        style_mods = { horizontal_spacing = 8 }
                    }
                }
            }
        })

        globalPlayer.guis.kanbanGuiMain = elems.kanbanGuiMain
        globalPlayer.guis.kanbanGuiListFlow = elems.kanbanGuiListFlow

        for i, listData in pairs(forceLists) do
            listGui.buildListGui(globalPlayer, listData, i, #forceLists)
        end

        flibGui.add(elems.kanbanGuiListFlow, {
            type = "button",
            caption = "Add new list",
            style_mods = { height = 54 / playerDisplayScale, width = 325 / playerDisplayScale },
            handler = { [eventsDefine.on_gui_click] = showAddList }
        })

        flibGui.add(elems.kanbanGuiListFlow, {
            type = "frame",
            style = "tasktorio_list_frame",
            direction = "vertical",
            visible = false,
            style_mods = { width = 325 / playerDisplayScale },
            {
                type = "flow",
                direction = "horizontal",
                style_mods = { vertical_align = "center", height = 40 / playerDisplayScale },
                {
                    type = "textfield",
                    style_mods = { width = 225 / playerDisplayScale },
                    handler = { [eventsDefine.on_gui_confirmed] = addList }
                },
                {
                    type = "empty-widget",
                    style = "flib_horizontal_pusher"
                },
                {
                    type = "sprite-button",
                    style = "tasktorio_naked_button",
                    sprite = "utility/check_mark_white",
                    style_mods = { size = 28 / playerDisplayScale },
                    handler = { [eventsDefine.on_gui_click] = addList }
                },
                {
                    type = "sprite-button",
                    style = "tasktorio_naked_button",
                    sprite = "utility/close",
                    style_mods = { size = 28 / playerDisplayScale, left_margin = -5 },
                    handler = { [eventsDefine.on_gui_click] = hideAddList }
                },
            }
        })
    end
end

flibGui.add_handlers({
    toggleMainGui = toggleMainGui,
    showAddList = showAddList,
    addList = addList,
    hideAddList = hideAddList
})

return kanbanGui
