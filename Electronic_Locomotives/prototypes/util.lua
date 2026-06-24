local modName = "__Electronic_Locomotives__"

return function (color)
    return {
        {
            icon = modName .. "/graphics/diesel-locomotive-base.png",
            icon_size = 32
        },
        {
            icon = modName .. "/graphics/diesel-locomotive-mask.png",
            icon_size = 32,
            tint = util.color(color)
        },
        {
            icon = modName .. "/graphics/electric-32.png",
            icon_size = 32,
            scale = 0.5,
            shift = { -5, -5 }
        }
    }
end