local meld = require("__core__.lualib.meld")

for i = 8, 11 do
    data:extend({
        meld(table.deepcopy(data.raw["technology"]["braking-force-7"]), {
            name = "braking-force-" .. i,
            prerequisites = { "braking-force-" .. i - 1 },
            unit = { count = ((i - 1) * 100) + 50 }
        })
    })
end