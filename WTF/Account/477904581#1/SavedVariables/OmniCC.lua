
OmniCCDB = {
	["global"] = {
		["dbVersion"] = 6,
		["addonVersion"] = "10.0.2",
	},
	["profileKeys"] = {
		["Zowl - Golemagg"] = "Default",
		["Tailcow - Golemagg"] = "Default",
		["Zandalar - Zandalar Tribe"] = "Default",
		["Meatcow - Golemagg"] = "Default",
		["Zandalara - Golemagg"] = "Default",
		["Herbcow - Golemagg"] = "Default",
		["Leathercow - Golemagg"] = "Default",
		["Zandalar - Golemagg"] = "Default",
		["Zandalar - Gandling"] = "Default",
		["Zandalar - Mograine"] = "Default",
		["Banger - Golemagg"] = "Default",
		["Azerot - Golemagg"] = "Default",
	},
	["profiles"] = {
		["Default"] = {
			["rules"] = {
				{
					["enabled"] = false,
					["patterns"] = {
						"Aura", -- [1]
						"Buff", -- [2]
						"Debuff", -- [3]
					},
					["name"] = "Auras",
					["id"] = "auras",
				}, -- [1]
				{
					["enabled"] = false,
					["patterns"] = {
						"Plate", -- [1]
					},
					["name"] = "Unit Nameplates",
					["id"] = "plates",
				}, -- [2]
				{
					["enabled"] = false,
					["patterns"] = {
						"ActionButton", -- [1]
					},
					["name"] = "ActionBars",
					["id"] = "actions",
				}, -- [3]
			},
			["themes"] = {
				["Default"] = {
					["textStyles"] = {
						["seconds"] = {
						},
						["soon"] = {
						},
						["minutes"] = {
						},
					},
				},
			},
		},
	},
}
OmniCC4Config = nil
