local flibGui = require("__flib__/gui")
local lib = require("__tasktorio__/scripts/gui/lib")
local eventsDefine = defines.events
local taskGui = {}

local function openTaskOverview(event)
    local element = event.element

    game.print(element.name .. " | " .. event.tick)
end

local function moveTaskElement(event)
    local element = event.element
    local taskElement = element.parent.parent.parent
    local taskFlowElement = taskElement.parent
    local listElement = taskFlowElement.parent.parent.parent
    local taskListData = storage.forceData[taskElement.tags.forceIndexString].lists[listElement.get_index_in_parent()].tasks
    local currentListId = taskElement.get_index_in_parent()
    local isBackwards = element.sprite == "tasktorio_arrow_up"
    local newListId = currentListId + (isBackwards and -1 or 2)

    if event.control then
        newListId = isBackwards and 1 or #taskListData + 1
    elseif event.shift then
        newListId = currentListId + (isBackwards and -5 or 6)
    end

    newListId = math.max(1, math.min(newListId, #taskListData + 1))

    local currentListEntry = table.remove(taskListData, currentListId)

    table.insert(taskListData, newListId - 1, currentListEntry)

    lib.moveChildren(taskFlowElement, currentListId, newListId)

    for _, childElement in pairs(taskFlowElement.children) do
        if childElement.tags and childElement.tags.forceIndexString then
            local indexInParent = childElement.get_index_in_parent()
            local childFlowElement = childElement.children[1].children[3]

            childFlowElement.children[1].enabled = indexInParent ~= 1
            childFlowElement.children[2].enabled = indexInParent ~= #taskListData
        end
    end
end

function taskGui.buildTaskGui(globalPlayer, taskFlow, taskData, taskEntry, totalEntries, globalTaskId)
    if taskFlow and taskFlow.valid then
        local playerDisplayScale = globalPlayer.displayScale

        local elems = flibGui.add(taskFlow, {
            type = "frame",
            name = "kanbanGuiTaskElement_" .. globalTaskId,
            style = "tasktorio_task_frame",
            direction = "vertical",
            tags = { forceIndexString = globalPlayer.forceIndexString, globalTaskId = globalTaskId },
            syle_mods = { horizontally_stretchable = true, margin = 0, padding = 0 },
            handler = { [eventsDefine.on_gui_click] = openTaskOverview },
            {
                type = "flow",
                direction = "horizontal",
                style_mods = { vertical_align = "center", height = 50 / playerDisplayScale, margin = { 3, 6 }, padding = 0 },
                {
                    type = "label",
                    style = "heading_2_label",
                    caption = taskData.title,
                    ignored_by_interaction = true,
                    style_mods = { width = 225 / playerDisplayScale },
                },
                {
                    type = "empty-widget",
                    style = "flib_horizontal_pusher",
                    ignored_by_interaction = true,
                },
                {
                    type = "flow",
                    direction = "vertical",
                    style_mods = { vertical_spacing = 0, top_padding = 2 },
                    {
                        type = "sprite-button",
                        style = "tasktorio_move_button",
                        sprite = "tasktorio-arrow-up",
                        enabled = taskEntry ~= 1,
                        style_mods = { size = { 24 / playerDisplayScale, 18 / playerDisplayScale }, padding = -1 },
                        handler = { [eventsDefine.on_gui_click] = moveTaskElement }
                    },
                    {
                        type = "sprite-button",
                        style = "tasktorio_move_button",
                        sprite = "tasktorio-arrow-down",
                        enabled = taskEntry ~= totalEntries,
                        style_mods = { size = { 24 / playerDisplayScale, 18 / playerDisplayScale }, padding = -1 },
                        handler = { [eventsDefine.on_gui_click] = moveTaskElement }
                    }
                }
            }
        })

        if #taskData.description > 0 then
            flibGui.add(elems["kanbanGuiTaskElement_" .. globalTaskId], {
                type = "flow",
                direction = "horizontal",
                ignored_by_interaction = true,
                style_mods = { height = 28 / playerDisplayScale, margin = { 0, 6, 3, 6 }, padding = 0 },
                {
                    type = "sprite",
                    sprite = "tasktorio-description",
                    resize_to_sprite = false,
                    style_mods = { size = 16 }
                }
            })

            elems["kanbanGuiTaskElement_" .. globalTaskId].children[1].style.margin = { 3, 6, 0, 6 }
        end

        globalPlayer.guis.tasks[tostring(globalTaskId)] = elems["kanbanGuiTaskElement_" .. globalTaskId]
    end
end

flibGui.add_handlers({
    openTaskOverview = openTaskOverview,
    moveTaskElement = moveTaskElement
})

return taskGui
