
OmniCCDB = {
	["global"] = {
		["dbVersion"] = 6,
		["addonVersion"] = "10.0.3",
	},
	["profileKeys"] = {
		["Zowl - Golemagg"] = "Default",
		["Tailcow - Golemagg"] = "Default",
		["Leathercow - Golemagg"] = "Default",
		["Zandalar - Zandalar Tribe"] = "Default",
		["Meatcow - Golemagg"] = "Default",
		["Zandalara - Golemagg"] = "Default",
		["Zandalar - Gehennas"] = "Default",
		["Herbcow - Golemagg"] = "Default",
		["Banger - Golemagg"] = "Default",
		["Zandalar - Gandling"] = "Default",
		["Zandalar - Golemagg"] = "Default",
		["Thezandalar - Mograine"] = "Default",
		["Zandalar - Mograine"] = "Default",
		["Azerot - Golemagg"] = "Default",
		["Thezandalar - Hydraxian Waterlords"] = "Default",
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
						["soon"] = {
						},
						["minutes"] = {
						},
						["seconds"] = {
						},
					},
				},
			},
		},
	},
}
OmniCC4Config = nil
