local modName = "__ColorblindCircuitNetwork__"

-- icon when item is 'in hand'
data.raw["item"]["green-wire"].icon = modName .. "/graphics/yellow-wire-icon.png"
data.raw["item"]["red-wire"].icon = modName .. "/graphics/blue-wire-icon.png"

-- custom-input icons for rhs of main quick select bar at bottom of screen
data.raw["shortcut"]["give-green-wire"].icon = modName .. "/graphics/new-yellow-wire-x56.png"
data.raw["shortcut"]["give-green-wire"].small_icon = modName .. "/graphics/new-yellow-wire-x24.png"
data.raw["shortcut"]["give-red-wire"].icon = modName .. "/graphics/new-blue-wire-x56.png"
data.raw["shortcut"]["give-red-wire"].small_icon = modName .. "/graphics/new-blue-wire-x24.png"

-- sprite used when rendering wires between poles, combinators, or other entities
data.raw["utility-sprites"].default.green_wire.filename = modName .. "/graphics/yellow-wire-sprite.png"
data.raw["utility-sprites"].default.red_wire.filename = modName .. "/graphics/blue-wire-sprite.png"
data.raw["utility-sprites"].default.copper_wire.filename = modName .. "/graphics/copper-wire-sprite.png"

-- background color for the gui popup on electric pole hover
data.raw["gui-style"].default.green_circuit_network_content_slot.default_graphical_set.position = { 148, 72 }
data.raw["gui-style"].default.red_circuit_network_content_slot.default_graphical_set.position = { 221, 72 }

-- background color for combinator input section
data.raw["gui-style"].default.green_slot.default_graphical_set = { base = { border = 4, position = { 80, 816 }, size = 80 } }
data.raw["gui-style"].default.green_slot.hovered_graphical_set = { base = { border = 4, position = { 80, 424 }, size = 80 } }
data.raw["gui-style"].default.green_slot.clicked_graphical_set = { base = { border = 4, position = { 160, 424 }, size = 80 } }

data.raw["gui-style"].default.red_slot.default_graphical_set = { base = { border = 4, position = { 0, 504 }, size = 80 } }
data.raw["gui-style"].default.red_slot.hovered_graphical_set = { base = { border = 4, position = { 80, 504 }, size = 80 } }
data.raw["gui-style"].default.red_slot.clicked_graphical_set = { base = { border = 4, position = { 160, 504 }, size = 80 } }
data.raw["gui-style"].default.red_slot.selected_graphical_set = { base = { border = 4, position = { 80, 504 }, size = 80 } }
