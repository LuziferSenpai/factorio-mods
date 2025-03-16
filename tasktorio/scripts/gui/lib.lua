local lib = {}

---@param parentElement LuaGuiElement
---@param fromIndex number
---@param toIndex number
function lib.moveChildren(parentElement, fromIndex, toIndex)
    local element = parentElement.children[fromIndex]
    local tempElement = parentElement.add({type = "empty-widget", index = toIndex})

    parentElement.swap_children(element.get_index_in_parent(), toIndex)

    tempElement.destroy()
end

return lib