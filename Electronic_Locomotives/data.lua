-- require("prototypes/standard-provider")
-- require("prototypes/heavy-provider")
-- require("prototypes/standard-locomotive")
-- require("prototypes/cargo-locomotive")
require("prototypes.provider")
require("prototypes.locomotives")
require("prototypes.electronic-technology")
require("prototypes.braking-force")
require("prototypes.fuel")


data:extend({
    {
        type = "fuel-category",
        name = "electronic"
    }
})
