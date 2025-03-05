local MODNAME = "__Automatic_Coupling_System__"

data:extend(
    {
        {
            type = "item-subgroup",
            name = "coupling-signals",
            group = "signals",
            order = "zz"
        },
        {
            type = "virtual-signal",
            name = "signal-couple",
            icon = MODNAME .. "/images/coupleSignal.png",
            subgroup = "coupling-signals",
            order = "a"
        },
        {
            type = "virtual-signal",
            name = "signal-decouple",
            icon = MODNAME .. "/images/decoupleSignal.png",
            subgroup = "coupling-signals",
            order = "b"
        },
        {
            type = "tips-and-tricks-item-category",
            name = "luzifers-mods",
            order = "s-[luzifers-mods]"
        },
        {
            type = "tips-and-tricks-item",
            name = "automatic-coupling-system",
            category = "luzifers-mods",
            order = "a",
            is_title = true,
            dependencies = { "train-stops", "circuit-network" },
            tutorial = "automatic-coupling-system"
        },
        {
            type = "tutorial",
            name = "automatic-coupling-system",
            scenario = "ACT"
        }
    }
)
