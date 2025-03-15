local modname = "__tasktorio__"
local defaultGuiStyle = data.raw["gui-style"].default

defaultGuiStyle.tasktorio_list_frame = {
    type = "frame_style",
    graphical_set = { base = { position = { 68, 0 }, corner_size = 8 } },
    padding = 4
}

defaultGuiStyle.tasktorio_task_frame = {
    type = "frame_style",
    graphical_set = {
        base = {
            position = { 85, 0 },
            corner_size = 8,
            center = { position = { 42, 8 }, size = { 1, 1 } },
            draw_type = "outer"
        },
        shadow = default_inner_shadow
    },
    padding = 0
}

defaultGuiStyle.tasktorio_list_header = {
    type = "label_style",
    parent = "clickable_label",
    font = "heading-2",
    vertical_align = "center",
    single_line = true
}

defaultGuiStyle.tasktorio_naked_button = {
    type = "button_style",
    parent = "button",
    minimal_width = 0,
    minimal_height = 0,
    padding = 4,
    default_graphical_set = {},
    hovered_graphical_set = {},
    clicked_graphical_set = {},
    disabled_graphical_set = {},
    invert_colors_of_picture_when_hovered_or_toggled = true
}

defaultGuiStyle.tasktorio_move_button = {
    type = "button_style",
    parent = "list_box_item",
    invert_colors_of_picture_when_hovered_or_toggled = true
}

data:extend({
    {
        type = "sprite",
        name = "tasktorio-arrow-up",
        filename = modname .. "/graphics/arrow_up.png",
        flags = { "gui-icon" },
        size = 32,
        mipmap_count = 2
    },
    {
        type = "sprite",
        name = "tasktorio-arrow-down",
        filename = modname .. "/graphics/arrow_down.png",
        flags = { "gui-icon" },
        size = 32,
        mipmap_count = 2
    },
    {
        type = "sprite",
        name = "tasktorio-description",
        filename = modname .. "/graphics/description.png",
        flags = { "gui-icon" },
        size = 64
    }
})
