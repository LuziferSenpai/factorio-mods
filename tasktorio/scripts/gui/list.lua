local flibGui = require("__flib__/gui")
local taskGui = require("__tasktorio__/scripts/gui/task")
local lib = require("__tasktorio__/scripts/gui/lib")
local eventsDefine = defines.events
local listGui = {}

local function showListNameTextField(event)
    local element = event.element

    element.visible = false
    element.parent.children[2].visible = true
    element.parent.children[2].focus()
end

local function changeListName(event)
    local element = event.element
    local listFlowElement = element.parent
    local listElement = listFlowElement.parent

    element.visible = false

    listFlowElement.children[1].visible = true
    listFlowElement.children[1].caption = element.text

    storage.forceData[listElement.tags.forceIndexString].lists[listElement.get_index_in_parent()].name = element.text
end

local function moveListElement(event)
    local element = event.element
    local listElement = element.parent.parent
    local listFlowElement = listElement.parent
    local forceListData = storage.forceData[listElement.tags.forceIndexString].lists
    local currentListId = listElement.get_index_in_parent()
    local isBackwards = element.sprite == "flib_nav_backward_white"
    local newListId = currentListId + (isBackwards and -1 or 2)

    if event.control then
        newListId = isBackwards and 1 or #forceListData + 1
    elseif event.shift then
        newListId = currentListId + (isBackwards and -5 or 6)
    end

    newListId = math.max(1, math.min(newListId, #forceListData + 1))

    local currentListEntry = table.remove(forceListData, currentListId)

    table.insert(forceListData, newListId - 1, currentListEntry)

    lib.moveChildren(listFlowElement, currentListId, newListId)

    for _, childElement in pairs(listFlowElement.children) do
        if childElement.tags and childElement.tags.forceIndexString then
            local indexInParent = childElement.get_index_in_parent()
            local childFlowElement = childElement.children[1]

            childFlowElement.children[4].enabled = indexInParent ~= 1
            childFlowElement.children[5].enabled = indexInParent ~= #forceListData
        end
    end
end

local function showAddTask(event)
    local element = event.element
    local addTaskElement = element.parent.children[#element.parent.children]

    element.visible = false

    addTaskElement.visible = true
    addTaskElement.children[1].children[1].text = ""
end

local function addTask(event)
    local textfieldElement = event.name == eventsDefine.on_gui_click and event.element.parent.parent.children[1] or event.element

    if #textfieldElement.text > 0 then
        local taskFlowElement = textfieldElement.parent.parent.parent
        local globalPlayer = storage.players[tostring(event.player_index)]
        local tasks = storage.forceData[globalPlayer.forceIndexString].lists[taskFlowElement.parent.parent.parent.get_index_in_parent()].tasks
        local allTasks = storage.allTasks

        table.insert(allTasks, {
            title = textfieldElement.text,
            description = ""
        })
        table.insert(tasks, #allTasks)

        taskGui.buildTaskGui(globalPlayer, taskFlowElement, allTasks[#allTasks], #tasks, #tasks, #allTasks)

        lib.moveChildren(taskFlowElement, #taskFlowElement.children, #taskFlowElement.children - 2)

        taskFlowElement.children[#taskFlowElement.children].visible = false
        taskFlowElement.children[#taskFlowElement.children - 1].visible = true
        taskFlowElement.parent.scroll_to_bottom()

        for _, childElement in pairs(taskFlowElement.children) do
            if childElement.tags and childElement.tags.forceIndexString then
                local indexInParent = childElement.get_index_in_parent()
                local childFlowElement = childElement.children[1].children[4]

                childFlowElement.children[1].enabled = indexInParent ~= 1
                childFlowElement.children[2].enabled = indexInParent ~= #tasks
            end
        end
    end
end

local function hideAddTask(event)
    local addTaskElement = event.element.parent.parent.parent

    addTaskElement.visible = false
    addTaskElement.parent.children[addTaskElement.get_index_in_parent() - 1].visible = true
end

function listGui.buildListGui(globalPlayer, listData, listEntry, totalEntries)
    local kanbanGuiListFlow = globalPlayer.guis.kanbanGuiListFlow

    if kanbanGuiListFlow and kanbanGuiListFlow.valid then
        local playerDisplayScale = globalPlayer.displayScale
        local allTasks = storage.allTasks

        local elems = flibGui.add(kanbanGuiListFlow, {
            type = "frame",
            style = "tasktorio_list_frame",
            direction = "vertical",
            tags = { forceIndexString = globalPlayer.forceIndexString },
            style_mods = { width = 325 / playerDisplayScale },
            {
                type = "flow",
                direction = "horizontal",
                style_mods = { vertical_align = "center", height = 40 / playerDisplayScale },
                {
                    type = "label",
                    style = "tasktorio_list_header",
                    caption = listData.name,
                    style_mods = { width = 225 / playerDisplayScale, left_margin = 4 },
                    handler = { [eventsDefine.on_gui_click] = showListNameTextField }
                },
                {
                    type = "textfield",
                    text = listData.name,
                    visible = false,
                    style_mods = { width = 225 / playerDisplayScale },
                    handler = { [eventsDefine.on_gui_confirmed] = changeListName }
                },
                {
                    type = "empty-widget",
                    style = "flib_horizontal_pusher"
                },
                {
                    type = "sprite-button",
                    style = "tasktorio_naked_button",
                    sprite = "flib_nav_backward_white",
                    enabled = listEntry ~= 1,
                    style_mods = { size = 28 / playerDisplayScale },
                    handler = { [eventsDefine.on_gui_click] = moveListElement }
                },
                {
                    type = "sprite-button",
                    style = "tasktorio_naked_button",
                    sprite = "flib_nav_forward_white",
                    enabled = listEntry ~= totalEntries,
                    style_mods = { size = 28 / playerDisplayScale, left_margin = -5 },
                    handler = { [eventsDefine.on_gui_click] = moveListElement }
                },
            },
            {
                type = "frame",
                style = "flib_shallow_frame_in_shallow_frame",
                direction = "vertical",
                {
                    type = "scroll-pane",
                    style = "flib_naked_scroll_pane_no_padding",
                    style_mods = {
                        maximal_height = (globalPlayer.displayResolution.height - 160) / playerDisplayScale,
                        minimal_height = 0,
                        horizontally_stretchable = true,
                        extra_right_padding_when_activated = 0
                    },
                    {
                        type = "flow",
                        name = "kanbanGuiTaskFlow",
                        direction = "vertical",
                        style_mods = { minimal_height = 0, vertical_spacing = 0 }
                    }
                }
            }
        })

        for i, globalTaskId in pairs(listData.tasks) do
            taskGui.buildTaskGui(globalPlayer, elems.kanbanGuiTaskFlow, allTasks[globalTaskId], i, #listData.tasks, globalTaskId)
        end

        flibGui.add(elems.kanbanGuiTaskFlow, {
            type = "button",
            caption = "Add new task",
            style_mods = { horizontally_stretchable = true, height = 50 / playerDisplayScale },
            handler = { [eventsDefine.on_gui_click] = showAddTask }
        })

        flibGui.add(elems.kanbanGuiTaskFlow, {
            type = "frame",
            style = "tasktorio_task_frame",
            visible = false,
            syle_mods = { horizontally_stretchable = true },
            {
                type = "flow",
                direction = "horizontal",
                style_mods = { vertical_align = "center", height = 50 / playerDisplayScale, padding = { 3, 6 } },
                {
                    type = "textfield",
                    style_mods = { width = 225 / playerDisplayScale },
                    handler = { [eventsDefine.on_gui_confirmed] = addTask }
                },
                {
                    type = "empty-widget",
                    style = "flib_horizontal_pusher"
                },
                {
                    type = "flow",
                    direction = "vertical",
                    style_mods = { vertical_spacing = 0, top_padding = 2 },
                    {
                        type = "sprite-button",
                        style = "tasktorio_move_button",
                        sprite = "utility/check_mark_white",
                        style_mods = { size = { 24 / playerDisplayScale, 18 / playerDisplayScale }, padding = -1 },
                        handler = { [eventsDefine.on_gui_click] = addTask }
                    },
                    {
                        type = "sprite-button",
                        style = "tasktorio_move_button",
                        sprite = "utility/close",
                        style_mods = { size = { 24 / playerDisplayScale, 18 / playerDisplayScale }, padding = -1 },
                        handler = { [eventsDefine.on_gui_click] = hideAddTask }
                    }
                }
            }
        })
    end
end

flibGui.add_handlers({
    showListNameTextField = showListNameTextField,
    changeListName = changeListName,
    moveListElement = moveListElement,
    showAddTask = showAddTask,
    addTask = addTask,
    hideAddTask = hideAddTask
})

return listGui
