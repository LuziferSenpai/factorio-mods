local modName = "__more-pipe-to-ground__"
local meld = require("__core__/lualib/meld")
local originalPipeToGroundEntity = data.raw["pipe-to-ground"]["pipe-to-ground"]
local originalPipeToGroundItem = data.raw["item"]["pipe-to-ground"]
local directions = {
    north = { "north", "east", "south", "west" },
    east = { "east", "south", "west", "north" },
    south = { "south", "west", "north", "east" },
    west = { "west", "north", "east", "south" },
}
local newPipeToGrounds = {
    {
        normal = { "west" },
        underground = { "south" },
        pictures = { { "left", "down" }, { "up", "left" }, { "right", "up" }, { "down", "right" } },
        blueprintString = "0eNp90NkKgzAQBdB/medJwVSL+iullKpDGagTydIFyb83WuhG7UMgCTfnJhmhOQUaLIuHegRujTiotyM4PsrhNO3JoSeoYeCBICKwdHSFOou4EFLeqKM1Qbq3uI47BBLPnulRMC9uewl9QzZ5+FGEMBiXwkYmPQFKr1cFwi3NsmpVxKn+i9C4cI0fmH5iZcIQOrbUPhLlD3q9QKuLKBf+F8y3Ta9nT30CXv+NcCbr5kPFRld5VRVp5FmZxXgH5e6Dzw=="
    },
    {
        normal = { "east" },
        underground = { "south" },
        pictures = { { "right", "down" }, { "down", "left" }, { "left", "up" }, { "up", "right" } },
        blueprintString = "0eNp9kEEOgjAQRe8y65ZYBBSuYoxRmZBJZEraYiSkd3eQhWLERZO2+f+9aUe43HrsHHGAagS6WvZQHUbw1PD5Nt3xuUWooKMOISogrvEBlYlqJaSD1Y2zPdcf8TQeFSAHCoSz4HUYTty3F3TCUysMBZ31UrM8eQSl002SKxhkZ4okF0dNDq9zYj+N9YVOV9AaWfv+v2Angh/I7QL5A2HKJUJeTwFbKbz/W8EdnX+V8iIts7LMZWVmb2J8Al0Ag7g="
    },
    {
        normal = { "east", "west" },
        underground = { "south" },
        pictures = { { "right-left", "down" }, { "up-down", "left" }, { "right-left", "up" }, { "up-down", "right" } },
        blueprintString = "0eNqFkesKwjAMhd8lv1Nhc9VtryIi0wUJuHS0nRdG391uA284/RFowsl3Ttse9qeOWsvioeyBD0YclJseHB+lOg0zqRqCElpuCQICS01XKJOAMyLljTpa00n9Ik/DFoHEs2eaDMbmtpOu2ZONPHwzQmiNi2IjAz0CVFIsNMJtOOmFDoP9ByLFmRhfYPkDlkUYQs2WDpMi/4JezqAVXUS57rfDTNzs743X74j4guypiQvPP0M4k3Xjkl6lRVYUOlaW5EkIdxHOmO0="
    },
    {
        normal = { "north", "east", "west" },
        underground = { "south" },
        pictures = { { "up-right-left", "down" }, { "up-right-down", "left" }, { "right-down-left", "up" }, { "up-down-left", "right" } },
        blueprintString = "0eNqF0W0LgjAQB/Dvcq+3QHOWfpWIyDziQG+yh0pk371pUEiWLwbbuP9vN26AqvHYGWIH5QB00WyhPAxg6crnZrzjc4tQQkcdQhBAXOMDyiQcBSA7coSvxHToT+zbCk0sELOkgE7bWKx5NCMgk3yjBPTjLtuoEMQXka4SuzexXSa2M0I6La9Ge67/95NGTEBNBi+viv0Cnf2gJeOdpfX/n/jRr1r9spoTcQrksI2BzyAF3NDYKaTytMiKQsWVJfskhCfUOp4X"
    },
    {
        normal = { "west" },
        underground = { "north", "south" },
        pictures = { { "left", "up", "down" }, { "up", "right", "left" }, { "right", "up", "down" }, { "down", "right", "left" } },
        blueprintString = "0eNqd0W0LgjAQB/Dvcq+3aOYi/SoRYXrEQd5km5XIvntToSe0F70YbOPu9z+2Hk6XFhtL7CHvgUrDDvJ9D47OXFyGOy5qhBwaalB6I8/WtFxBEEBc4R1yFcRC+VtREg4CkD15wilgPHRHbusT2qiIhSABjXGxzfCgR0qqdKUFdMMuWekwxH9hyQc2R+gnoeaJzV/zrCMmoCKL5VSxm6HTBVreWLJrfyeM48a3JI91FF6/J+CK1o1NeptkaZbpuFK1UyE8AG/DnKQ="
    },
    {
        normal = { "north" },
        underground = { "south", "west" },
        pictures = { { "up", "down", "left" }, { "right", "up", "left" }, { "down", "up", "right" }, { "left", "right", "down" } },
        blueprintString = "0eNqV0duKwjAQBuB3meuJbNJ2afsqIovaQQbspCSpq5S8u4myB6UVvAgk4Z9vhmSC3XGkwbEEaCfgvRUP7XoCzwfZHvOdbHuCFgYeSAWrDs6O0kFEYOnoDK2OuBD/FzJxg0ASODDdG9wOly8Z+x25pOBDJcJgfQpbyWYClDarCuGSdx+rKuamT4TBhVlnsOIHa5KF0LGj/T2gzQxdvEH/zlk/0/WMXC7ISkT57/Flgzx7flcO1Cfg7ycRTuT8rab6NE3ZNFVapa51jFf1/KDt"
    },
    {
        normal = { "north" },
        underground = { "east", "south" },
        pictures = { { "up", "right", "down" }, { "right", "down", "left" }, { "down", "up", "left" }, { "left", "up", "right" } },
        blueprintString = "0eNqNkcsKgzAQRf9l1pNSrVr1V0opPoYyUCeSxNIi+fdGXfRBLV0EkuHk3EsyQn0ZqDcsDsoRuNFioTyMYPks1WWaSdURlNBzT8ppdTZ6kBY8AktLNygjjyv4CxT7IwKJY8e0BMyH+0mGriYTLPh2E6HXNsBaJmcQqGi7SRHuYZdvUj9lfhhiXKn6y5UFF0LLhpoFyL+YdytmJaLIDj8D9t/LJv+XLV5Vb12T6VHZURc0z29EuJKxM5BmcZEURRpWEuWR9w9sL6BM"
    },
    {
        normal = { "east", "west" },
        underground = { "north", "south" },
        pictures = { { "right-left", "up", "down" }, { "up-down", "right", "left" }, { "right-left", "up", "down" }, { "up-down", "right", "left" } },
        blueprintString = "0eNqd0e8KgjAQAPB3uc9boLlSXyUiNI840JtssxLZuzeLKEML+jDYn7vf3bgByrrD1hA7yAego2YL+W4ASycu6vGOiwYhh5ZaBC+AuMIr5JEXC0HSaXkyuuPqLTz2ewHIjhzho8D90B+4a0o0wRMLhoBW25CmeawTKJmulIA+bDYr5cc2Pqh4Qs0A2RNQ88D6j16SQAmoyODx8Z7OwMkCLPHCkm33rcBCr+rXZ7cTIEyBHDYh/DV3AWc09p6iNnGWZJkKK4nSyPsbVj+v9g=="
    },
    {
        normal = { "north", "east" },
        underground = { "south", "west" },
        pictures = { { "up-right", "down", "left" }, { "right-down", "up", "left" }, { "down-left", "up", "right" }, { "up-left", "right", "down" } },
        blueprintString = "0eNqN0u+KwjAMAPB3yedUWLd6bq9yHDJdkIBLR9udyui72yl6p7fpfSj0T/pLSDvAZt9T51gCVAPw1oqH6nMAzzup9+Oe1C1BBR13BBGBpaEjVFnEmSAVrNo520vzK1zHLwSSwIHpmuCyOK2lbzfkkocPiRA661OwlVFPgFouDMIpTYqFiWPyJ0DjTBF/qY8blScKoWFH2+t5pifk/P/yvUj9LK8m4GIGVkKi/KF/lSCf7oJ510bzAKRH4UBtCv/5Bgjf5PzlilnqsihLk0aRrbIYz5X8tLA="
    },
    {
        normal = { "north" },
        underground = { "east", "south", "west" },
        pictures = { { "up", "right", "down", "left" }, { "right", "down", "left", "up" }, { "down", "left", "up", "right" }, { "left", "up", "right", "down" } },
        blueprintString = "0eNqN0dsKwjAMBuB3yXUqdmvF7VVERF2QgEtH23lg9N3t9ELFKV4U0vbPRyAD7I49dZ4lQj0A750EqFcDBD7I9ji+ybYlqKHjjlR06uBdLw0kBJaGLlDrtEYgiRyZHr33y3UjfbsjnwP4agBC50IOOxn1DCgzswjXXBQzmxJ+AAVOD6FEFIVz/4vU02T5hfxFzTOF0LCn/eN/OQGb/2H7OuMbrIsJ2f4vl19lMy6LI7WZeW4e4UQ+3AN2UVSmqmw+Ri91SjefBrDq"
    },
}
local undergroundCollisionMask = { layers = { lava_tile = true } }

if mods["space-age"] then
    undergroundCollisionMask = { layers = { empty_space = true, lava_tile = true } }
end

for i, newPipeToGround in pairs(newPipeToGrounds) do
    local name = "pipe-to-ground-"
    local pipeConnections = {}
    local icons = { {
        icon = modName .. "/graphics/pipe-to-ground/" .. newPipeToGround.pictures[1][1] .. ".png",
        icon_size = 128,
        scale = 0.5
    } }
    local pictures = {}
    local visualization = {}
    local disabledVisualization = {}
    local localisedName = { "", { "entity-name.pipe-to-ground" }, " (" }
    local localisedDescription = { "", { "connection.normal" }, ": " }

    for j = 2, #newPipeToGround.pictures[1] do
        icons[j] = {
            icon = modName .. "/graphics/arrow/" .. newPipeToGround.pictures[1][j] .. ".png",
            icon_size = 128,
            scale = 0.25
        }
    end

    for j, direction in pairs(directions.north) do
        pictures[direction] = {
            layers = { {
                filename = modName .. "/graphics/pipe-to-ground/" .. newPipeToGround.pictures[j][1] .. ".png",
                size = 128,
                scale = 0.5
            } }
        }

        for k = 2, #newPipeToGround.pictures[j] do
            pictures[direction].layers[k] = {
                filename = modName .. "/graphics/arrow/" .. newPipeToGround.pictures[j][k] .. ".png",
                size = 128,
                scale = 0.25
            }
        end

        visualization[direction] = {
            layers = { {
                filename = modName .. "/graphics/visualization/dot.png",
                size = 64,
                scale = 0.5,
                flags = { "icon" }
            } }
        }
        disabledVisualization[direction] = {
            layers = { {
                filename = modName .. "/graphics/disabled-visualization/dot.png",
                size = 64,
                scale = 0.5,
                flags = { "icon" }
            } }
        }
    end

    for j, direction in pairs(newPipeToGround.normal) do
        table.insert(pipeConnections, { direction = defines.direction[direction], position = { 0, 0 } })

        if j > 1 then
            table.insert(localisedName, "-")
            table.insert(localisedDescription, ", ")
        end

        table.insert(localisedName, { "direction." .. direction })
        table.insert(localisedDescription, { "direction." .. direction })

        name = name .. "" .. string.sub(direction, 1, 1)

        for k, visualizationDirection in pairs(directions.north) do
            table.insert(visualization[visualizationDirection].layers, {
                filename = modName .. "/graphics/visualization/" .. directions[direction][k] .. ".png",
                size = 64,
                scale = 0.5,
                flags = { "icon" }
            })
            table.insert(disabledVisualization[visualizationDirection].layers, {
                filename = modName .. "/graphics/disabled-visualization/" .. directions[direction][k] .. ".png",
                size = 64,
                scale = 0.5,
                flags = { "icon" }
            })
        end
    end

    name = name .. "n-"

    table.insert(localisedName, " → ")
    table.insert(localisedDescription, "\n")
    table.insert(localisedDescription, { "connection.underground" })
    table.insert(localisedDescription, ": ")

    for j, direction in pairs(newPipeToGround.underground) do
        table.insert(pipeConnections, {
            connection_type = "underground",
            direction = defines.direction[direction],
            position = { 0, 0 },
            max_underground_distance = 10,
            connection_category = { "default" },
            underground_collision_mask = undergroundCollisionMask,
        })

        if j > 1 then
            table.insert(localisedName, "-")
            table.insert(localisedDescription, ", ")
        end

        table.insert(localisedName, { "direction." .. direction })
        table.insert(localisedDescription, { "direction." .. direction })

        name = name .. "" .. string.sub(direction, 1, 1)
    end

    name = name .. "u"

    table.insert(localisedName, ")")

    data:extend({
        meld(table.deepcopy(originalPipeToGroundEntity), {
            name = name,
            minable = { result = name },
            icon = meld.delete(),
            icons = meld.overwrite(icons),
            localised_name = localisedName,
            localised_description = localisedDescription,
            factoriopedia_simulation = meld.overwrite({
                init =
                [[
                    game.simulation.camera_position = { 0.5, 0.5 }
                    game.surfaces[1].create_entities_from_blueprint_string
                    {
                        string = "]] .. newPipeToGround.blueprintString .. [[",
                        position = { 0, 0 }
                    }
                ]]
            }),
            fluid_box = {
                pipe_connections = meld.overwrite(pipeConnections)
            },
            pictures = meld.overwrite(pictures),
            visualization = meld.overwrite(visualization),
            disabled_visualization = meld.overwrite(disabledVisualization),
            npt_compat = { mod = "more-pipe-to-ground", override = "pipe", override_underground = "pipe-to-ground" }
        }),
        meld(table.deepcopy(originalPipeToGroundItem), {
            name = name,
            icon = meld.delete(),
            icons = meld.overwrite(icons),
            order = "a[pipe]-" .. string.char(98 + i) .. "[" .. name .. "]",
            place_result = name
        }),
        {
            type = "recipe",
            name = name,
            enabled = false,
            ingredients = {
                { type = "item", name = "pipe-to-ground", amount = #newPipeToGround.underground },
                { type = "item", name = "iron-plate",     amount = #newPipeToGround.normal }
            },
            results = { { type = "item", name = name, amount = 1 } }
        }
    })

    table.insert(data.raw.technology["steam-power"].effects, {
        type = "unlock-recipe",
        recipe = name
    })
end
