script.on_event(defines.events.on_surface_created, function(event)
    local surface = game.surfaces[event.surface_index]
    local planet = game.planets[surface.name]

    if planet then
        ---@type string
        local settingsValue = settings.startup["global-network-setting"].value

        if settingsValue == "for-free" then
            if not surface.has_global_electric_network then
                surface.create_global_electric_network()
            end
        elseif settingsValue == "planetary-research" then
            local technologies = game.forces.player.technologies

            if technologies["global-power-network-" .. planet.name] and technologies["global-power-network-" .. planet.name].researched then
                if not surface.has_global_electric_network then
                    surface.create_global_electric_network()
                end
            end
        elseif settingsValue == "endgame-research" then
            local globalPowerNetworkTechnology = game.forces.player.technologies["global-power-network"]

            if globalPowerNetworkTechnology and globalPowerNetworkTechnology.researched then
                if not surface.has_global_electric_network then
                    surface.create_global_electric_network()
                end
            end
        end
    end
end)

script.on_event(defines.events.on_research_finished, function(event)
    local settingsValue = settings.startup["global-network-setting"].value
    local technology = event.research

    if settingsValue == "for-free" then return
    elseif settingsValue == "planetary-research" then
        if string.find(technology.name, "global%-power%-network-") then
            local planet = game.planets[technology.name:gsub("global%-power%-network%-", "")]

            if planet then
                local surface = planet.surface

                if surface then
                    if not surface.has_global_electric_network then
                        surface.create_global_electric_network()
                    end
                end
            end
        end
    elseif settingsValue == "endgame-research" then
        if technology.name == "global-power-network" then
            for _, planet in pairs(game.planets) do
                local surface = planet.surface

                if surface then
                    if not surface.has_global_electric_network then
                        surface.create_global_electric_network()
                    end
                end
            end
        end
    end
end)

script.on_init(function()
    ---@type string
    local settingsValue = settings.startup["global-network-setting"].value

    if settingsValue == "for-free" then
        for _, planet in pairs(game.planets) do
            local surface = planet.surface

            if surface then
                if not surface.has_global_electric_network then
                    surface.create_global_electric_network()
                end
            end
        end
    elseif settingsValue == "planetary-research" then
        local technologies = game.forces.player.technologies

        for _, planet in pairs(game.planets) do
            local technology = technologies["global-power-network-" .. planet.name]

            if technology then
                local surface = planet.surface

                if surface then
                    if technology.researched then
                        if not surface.has_global_electric_network then
                            surface.create_global_electric_network()
                        end
                    end
                end
            end
        end
    elseif settingsValue == "endgame-research" then
        local globalPowerNetworkTechnology = game.forces.player.technologies["global-power-network"]

        if globalPowerNetworkTechnology and globalPowerNetworkTechnology.researched then
            for _, planet in pairs(game.planets) do
                local surface = planet.surface

                if surface then
                    if not surface.has_global_electric_network then
                        surface.create_global_electric_network()
                    end
                end
            end
        end
    end
end)

script.on_configuration_changed(function(event)
    if event.mod_startup_settings_changed then
        ---@type string
        local settingsValue = settings.startup["global-network-setting"].value

        if settingsValue == "for-free" then
            for _, planet in pairs(game.planets) do
                local surface = planet.surface

                if surface then
                    if not surface.has_global_electric_network then
                        surface.create_global_electric_network()
                    end
                end
            end
        elseif settingsValue == "planetary-research" then
            local technologies = game.forces.player.technologies

            for _, planet in pairs(game.planets) do
                if technologies["global-power-network-" .. planet.name] then
                    local surface = planet.surface

                    if surface then
                        if technologies["global-power-network-" .. planet.name].researched then
                            if not surface.has_global_electric_network then
                                surface.create_global_electric_network()
                            end
                        else
                            if surface.has_global_electric_network then
                                surface.destroy_global_electric_network()
                            end
                        end
                    end
                end
            end
        elseif settingsValue == "endgame-research" then
            local globalPowerNetworkTechnology = game.forces.player.technologies["global-power-network"]

            if globalPowerNetworkTechnology and globalPowerNetworkTechnology.researched then
                for _, planet in pairs(game.planets) do
                    local surface = planet.surface

                    if surface then
                        if not surface.has_global_electric_network then
                            surface.create_global_electric_network()
                        end
                    end
                end
            else
                for _, planet in pairs(game.planets) do
                    local surface = planet.surface

                    if surface then
                        if surface.has_global_electric_network then
                            surface.destroy_global_electric_network()
                        end
                    end
                end
            end
        end
    end
end)
