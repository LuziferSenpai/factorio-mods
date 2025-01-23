# Electronic-Locomotives

New locomotives that run on electricity, that gets provided by special providers.
Modders can add their own locomotives & providers.

Adds 4 more [Braking force](https://wiki.factorio.com/Braking_force_(research)) technologies to the game.
Also the `max_speed` for the standard cargo & fluid wagon are increased to 3, from 1. Only if the `max_speed` is under 3.

## How to add own locomotives & providers.
- Simply add a `is_electronic` to the prototype.
  - A locomotive will automaticly change its burner to the one used by this mod.
  - A provider does not add anything to the prototype.
  - A provider **NEEDS** to be a [ElectricEnergyInterfacePrototype](https://lua-api.factorio.com/latest/prototypes/ElectricEnergyInterfacePrototype.html).
  - The energy source should be set to `primary-input` for `usage_priority`.
