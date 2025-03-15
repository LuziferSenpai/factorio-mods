local handler = require("event_handler")

handler.add_libraries({
    require("__flib__/gui"),
    require("__tasktorio__/scripts/events"),
    require("__tasktorio__/scripts/gui/kanban"),
    require("__tasktorio__/scripts/gui/list"),
    require("__tasktorio__/scripts/gui/task")
})
