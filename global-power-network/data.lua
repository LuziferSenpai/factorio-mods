local modname = "__global-power-network__"
local spaceAge = "__space-age__"
local settingsValue = settings.startup["global-network-setting"].value

if settingsValue == "planetary-research" then
    data:extend({
        {
            type = "technology",
            name = "global-power-network-nauvis",
            icons = {
                {
                    icon = modname .. "/graphics/nauvis.png",
                    icon_size = 256
                },
                {
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    scale = 0.5,
                    shift = { 48, 48 }
                }
            },
            effects = {
                {
                    type = "nothing",
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    effect_description = { "global-power-network.global-planetary-network-effect", { "space-location-name.nauvis" } }
                }
            },
            prerequisites = { "space-science-pack" },
            unit = {
                count = 1000,
                ingredients =
                {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack", 1 },
                    { "chemical-science-pack", 1 },
                    { "space-science-pack", 1 }
                },
                time = 60
            },
            localised_name = { "global-power-network.global-planetary-network-name", { "", " ", { "space-location-name.nauvis" } } }
        },
        {
            type = "technology",
            name = "global-power-network-fulgora",
            icons = {
                {
                    icon = spaceAge .. "/graphics/technology/fulgora.png",
                    icon_size = 256
                },
                {
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    scale = 0.5,
                    shift = { 48, 48 }
                }
            },
            effects = {
                {
                    type = "nothing",
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    effect_description = { "global-power-network.global-planetary-network-effect", { "space-location-name.fulgora" } }
                }
            },
            prerequisites = { "electromagnetic-science-pack" },
            unit = {
                count = 1000,
                ingredients =
                {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack", 1 },
                    { "chemical-science-pack", 1 },
                    { "space-science-pack", 1 },
                    { "electromagnetic-science-pack", 1 }
                },
                time = 60
            },
            localised_name = { "global-power-network.global-planetary-network-name", { "", " ", { "space-location-name.fulgora" } } }
        },
        {
            type = "technology",
            name = "global-power-network-gleba",
            icons = {
                {
                    icon = spaceAge .. "/graphics/technology/gleba.png",
                    icon_size = 256
                },
                {
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    scale = 0.5,
                    shift = { 48, 48 }
                }
            },
            effects = {
                {
                    type = "nothing",
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    effect_description = { "global-power-network.global-planetary-network-effect", { "space-location-name.gleba" } }
                }
            },
            prerequisites = { "agricultural-science-pack" },
            unit = {
                count = 1000,
                ingredients =
                {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack", 1 },
                    { "chemical-science-pack", 1 },
                    { "space-science-pack", 1 },
                    { "agricultural-science-pack", 1 }
                },
                time = 60
            },
            localised_name = { "global-power-network.global-planetary-network-name", { "", " ", { "space-location-name.gleba" } } }
        },
        {
            type = "technology",
            name = "global-power-network-vulcanus",
            icons = {
                {
                    icon = spaceAge .. "/graphics/technology/vulcanus.png",
                    icon_size = 256
                },
                {
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    scale = 0.5,
                    shift = { 48, 48 }
                }
            },
            effects = {
                {
                    type = "nothing",
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    effect_description = { "global-power-network.global-planetary-network-effect", { "space-location-name.vulcanus" } }
                }
            },
            prerequisites = { "metallurgic-science-pack" },
            unit = {
                count = 1000,
                ingredients =
                {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack", 1 },
                    { "chemical-science-pack", 1 },
                    { "space-science-pack", 1 },
                    { "metallurgic-science-pack", 1 }
                },
                time = 60
            },
            localised_name = { "global-power-network.global-planetary-network-name", { "", " ", { "space-location-name.vulcanus" } } }
        },
        {
            type = "technology",
            name = "global-power-network-aquilo",
            icons = {
                {
                    icon = spaceAge .. "/graphics/technology/aquilo.png",
                    icon_size = 256
                },
                {
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    scale = 0.5,
                    shift = { 48, 48 }
                }
            },
            effects = {
                {
                    type = "nothing",
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    effect_description = { "global-power-network.global-planetary-network-effect", { "space-location-name.aquilo" } }
                }
            },
            prerequisites = { "cryogenic-science-pack" },
            unit = {
                count = 3000,
                ingredients =
                {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack", 1 },
                    { "chemical-science-pack", 1 },
                    { "production-science-pack", 1 },
                    { "utility-science-pack", 1 },
                    { "space-science-pack", 1 },
                    { "metallurgic-science-pack", 1 },
                    { "agricultural-science-pack", 1 },
                    { "electromagnetic-science-pack", 1 },
                    { "cryogenic-science-pack", 1 }
                },
                time = 60
            },
            localised_name = { "global-power-network.global-planetary-network-name", { "", " ", { "space-location-name.aquilo" } } }
        }
    })
elseif settingsValue == "endgame-research" then
    data:extend({
        {
            type = "technology",
            name = "global-power-network",
            icon = modname .. "/graphics/power-solo.png",
            icon_size = 256,
            effects = {
                {
                    type = "nothing",
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    effect_description = { "global-power-network.global-planetary-network-effect", { "space-location-name.nauvis" } }
                },
                {
                    type = "nothing",
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    effect_description = { "global-power-network.global-planetary-network-effect", { "space-location-name.fulgora" } }
                },
                {
                    type = "nothing",
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    effect_description = { "global-power-network.global-planetary-network-effect", { "space-location-name.gleba" } }
                },
                {
                    type = "nothing",
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    effect_description = { "global-power-network.global-planetary-network-effect", { "space-location-name.vulcanus" } }
                },
                {
                    type = "nothing",
                    icon = modname .. "/graphics/power.png",
                    icon_size = 128,
                    effect_description = { "global-power-network.global-planetary-network-effect", { "space-location-name.aquilo" } }
                }
            },
            prerequisites = { "promethium-science-pack" },
            unit = {
                count = 2000,
                ingredients =
                {
                    { "automation-science-pack", 1 },
                    { "logistic-science-pack", 1 },
                    { "chemical-science-pack", 1 },
                    { "production-science-pack", 1 },
                    { "utility-science-pack", 1 },
                    { "space-science-pack", 1 },
                    { "metallurgic-science-pack", 1 },
                    { "agricultural-science-pack", 1 },
                    { "electromagnetic-science-pack", 1 },
                    { "cryogenic-science-pack", 1 },
                    { "promethium-science-pack", 1 }
                },
                time = 60
            },
            localised_name = { "global-power-network.global-planetary-network-name", "" }
        }
    })
end
