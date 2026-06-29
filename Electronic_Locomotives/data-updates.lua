local meld = require("__core__.lualib.meld")
local auto = { "automation-science-pack", 1 }
local log = { "logistic-science-pack", 1 }
local chem = { "chemical-science-pack", 1 }
local prod = { "production-science-pack", 1 }
local util = { "utility-science-pack", 1 }
local mel = { "metallurgic-science-pack", 1 }
local elec = { "electromagnetic-science-pack", 1 }
local cryo = { "cryogenic-science-pack", 1 }
local prom = { "promethium-science-pack", 1 }

if mods["space-age"] then
    meld.meld(data.raw.recipe["electronic-locomotive-3"], {
        ingredients = meld.append({
            { type = "item", name = "tungsten-carbide", amount = 5 }
        })
    })

    meld.meld(data.raw.recipe["electronic-locomotive-4"], {
        ingredients = meld.append({
            { type = "item", name = "tungsten-plate", amount = 10 }
        })
    })

    meld.meld(data.raw.recipe["electronic-locomotive-5"], {
        ingredients = meld.append({
            { type = "item", name = "superconductor", amount = 5 }
        })
    })

    meld.meld(data.raw.recipe["electronic-locomotive-6"], {
        ingredients = meld.append({
            { type = "item", name = "superconductor", amount = 10 },
            { type = "item", name = "holmium-plate", amount = 5 }
        })
    })

    meld.meld(data.raw.recipe["electronic-provider-3"], {
        ingredients = meld.append({
            { type = "item", name = "tungsten-plate", amount = 5 }
        })
    })

    meld.meld(data.raw.recipe["electronic-provider-4"], {
        ingredients = meld.append({
            { type = "item", name = "superconductor", amount = 10 },
            { type = "item", name = "holmium-plate", amount = 5 }
        })
    })

    meld.meld(data.raw.technology["electronic-locomotives-3"], {
        prerequisites = meld.append({ "metallurgic-science-pack" }),
        unit = {
            ingredients = meld.append({ mel })
        }
    })

    meld.meld(data.raw.technology["electronic-locomotives-4"], {
        unit = {
            ingredients = meld.append({ mel })
        }
    })

    meld.meld(data.raw.technology["electronic-locomotives-5"], {
        prerequisites = meld.append({ "electromagnetic-science-pack" }),
        unit = {
            ingredients = meld.append({ mel, elec })
        }
    })

    meld.meld(data.raw.technology["electronic-locomotives-6"], {
        unit = {
            ingredients = meld.append({ mel, elec })
        }
    })

    meld.meld(data.raw.technology["electronic-locomotives-7"], {
        prerequisites = meld.append({ "cryogenic-science-pack" }),
        unit = {
            ingredients = meld.overwrite({ auto, log, chem, prod, util, mel, elec, cryo })
        }
    })

    meld.meld(data.raw.technology["electronic-locomotives-8"], {
        unit = {
            ingredients = meld.overwrite({ auto, log, chem, prod, util, mel, elec, cryo })
        }
    })

    meld.meld(data.raw.technology["electronic-locomotives-9"], {
        unit = {
            ingredients = meld.overwrite({ auto, log, chem, prod, util, mel, elec, cryo })
        }
    })

    meld.meld(data.raw.technology["electronic-locomotives-10"], {
        prerequisites = meld.append({ "promethium-science-pack" }),
        unit = {
            ingredients = meld.overwrite({ auto, log, chem, prod, util, mel, elec, cryo, prom })
        }
    })
end

meld.meld(data.raw.locomotive.locomotive, {
    fast_replaceable_group = "electronic-locomotives",
    next_upgrade = "electronic-locomotive-1",
})