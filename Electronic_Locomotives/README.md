# Electronic-Locomotives

New locomotives that run on electricity, that gets provided by special providers.
Modders can add there own locomotives & providers.

Adds 4 more [Braking force](https://wiki.factorio.com/Braking_force_(research)) technologies to the game.

Thanks to [snouz](https://mods.factorio.com/user/snouz) for making the locomotive icon colorable.

## How to add own locomotives & providers.
- Simply add a `is_electronic` to the prototype.
  - A locomotive will automaticly change its burner to the one used by this mod.
  - A provider does not add anything to the prototype.
  - A provider **NEEDS** to be a [ElectricEnergyInterfacePrototype](https://lua-api.factorio.com/latest/prototypes/ElectricEnergyInterfacePrototype.html).
  - The energy source should be set to `primary-input` for `usage_priority`.