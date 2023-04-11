
OmniCCDB = {
	["global"] = {
		["dbVersion"] = 6,
		["addonVersion"] = "10.0.5",
	},
	["profileKeys"] = {
		["Maffoboss - Golemagg"] = "Default",
		["Meatcow - Golemagg"] = "Default",
		["Zandalara - Golemagg"] = "Default",
		["Leathercow - Golemagg"] = "Default",
		["Zandalar - Golemagg"] = "Default",
		["Banger - Golemagg"] = "Default",
		["Potioncow - Golemagg"] = "Default",
		["Enchancow - Golemagg"] = "Default",
		["Tailcow - Golemagg"] = "Default",
		["Azerot - Golemagg"] = "Default",
		["Herbcow - Golemagg"] = "Default",
		["Zandalar - Zandalar Tribe"] = "Default",
		["Zandalar - Mograine"] = "Default",
		["Zandalar - Gandling"] = "Default",
		["Alchemcow - Golemagg"] = "Default",
		["Zowl - Golemagg"] = "Default",
		["Lickmenow - Golemagg"] = "Default",
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
