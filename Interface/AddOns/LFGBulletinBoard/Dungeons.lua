local TOCNAME,GBB=...

local function getSeasonalDungeons()
    local events = {}

    for eventName, eventData in pairs(GBB.Seasonal) do
		table.insert(events, eventName)
        if GBB.Tool.InDateRange(eventData.startDate, eventData.endDate) then
			GBB.SeasonalActiveEvents[eventName] = true
        end
    end
	return events
end

function GBB.GetDungeonNames()
	local DefaultEnGB={
		["RFC"] = 	"Ragefire Chasm",
		["DM"] = 	"The Deadmines",
		["WC"] = 	"Wailing Caverns",
		["SFK"] = 	"Shadowfang Keep",
		["STK"] = 	"The Stockade",
		["BFD"] = 	"Blackfathom Deeps",
		["GNO"] = 	"Gnomeregan",
		["RFK"] = 	"Razorfen Kraul",
		["SM2"] =	"Scarlet Monastery",
		["SMG"] = 	"Scarlet Monastery: Graveyard",
		["SML"] = 	"Scarlet Monastery: Library",
		["SMA"] = 	"Scarlet Monastery: Armory",
		["SMC"] = 	"Scarlet Monastery: Cathedral",
		["RFD"] = 	"Razorfen Downs",
		["ULD"] = 	"Uldaman",
		["ZF"] = 	"Zul'Farrak",
		["MAR"] = 	"Maraudon",
		["ST"] = 	"The Sunken Temple",
		["BRD"] = 	"Blackrock Depths",
		["DM2"] = 	"Dire Maul",
		["DME"] = 	"Dire Maul: East",
		["DMN"] = 	"Dire Maul: North",
		["DMW"] = 	"Dire Maul: West",
		["STR"] = 	"Stratholme",
		["SCH"] = 	"Scholomance",
		["LBRS"] = 	"Lower Blackrock Spire",
		["UBRS"] = 	"Upper Blackrock Spire (10)",
		["RAMPS"] = "Hellfire Citadel: Ramparts",
		["BF"] = 	"Hellfire Citadel: Blood Furnace",
		["SP"] = 	"Coilfang Reservoir: Slave Pens",
		["UB"] = 	"Coilfang Reservoir: Underbog",
		["MT"] = 	"Auchindoun: Mana Tombs",
		["CRYPTS"] = "Auchindoun: Auchenai Crypts",
		["SETH"] = 	"Auchindoun: Sethekk Halls",
		["OHB"] = 	"Caverns of Time: Old Hillsbrad",
		["MECH"] = 	"Tempest Keep: The Mechanar",
		["BM"] = 	"Caverns of Time: Black Morass",
		["MGT"] = 	"Magisters' Terrace",
		["SH"] = 	"Hellfire Citadel: Shattered Halls",
		["BOT"] = 	"Tempest Keep: Botanica",
		["SL"] = 	"Auchindoun: Shadow Labyrinth",
		["SV"] = 	"Coilfang Reservoir: Steamvault",
		["ARC"] = 	"Tempest Keep: The Arcatraz",
		["KARA"] = 	"Karazhan",
		["GL"] = 	"Gruul's Lair",
		["MAG"] = 	"Hellfire Citadel: Magtheridon's Lair",
		["SSC"] = 	"Coilfang Reservoir: Serpentshrine Cavern",

		["UK"] = 	"Utgarde Keep",
		["NEX"] = 	"The Nexus",
		["AZN"] = 	"Azjol-Nerub",
		["ANK"] = 	"Ahn???kahet: The Old Kingdom",
		["DTK"] = 	"Drak???Tharon Keep",
		["VH"] = 	"Violet Hold",
		["GD"] = 	"Gundrak",
		["HOS"] = 	"Halls of Stone",
		["HOL"] = 	"Halls of Lightning",
		["COS"] = 	"The Culling of Stratholme",
		["OCC"] = 	"The Oculus",
		["UP"] = 	"Utgarde Pinnacle",
		["FOS"] = 	"Forge of Souls",
		["POS"] = 	"Pit of Saron",
		["HOR"] = 	"Halls of Reflection",
		["CHAMP"] = "Trial of the Champion",
		["NAXX"] = 	"Naxxramas",

		["OS"]   =  "Obsidian Sanctum",
		["VOA"] = 	"Vault of Archavon",
		["EOE"] = 	"Eye of Eternity",
		["ULDAR"] =   "Ulduar",
		["TOTC"] = 	"Trial of the Crusader",
		["RS"] = 	"Ruby Sanctum",
		["ICC"] = 	"Icecrown Citadel",

		["EYE"] = 	"Tempest Keep: The Eye",
		["ZA"] = 	"Zul-Aman",
		["HYJAL"] = "The Battle For Mount Hyjal",
		["BT"] = 	"Black Temple",
		["SWP"] = 	"Sunwell Plateau",
		["ONY"] = 	"Onyxia's Lair (40)",
		["MC"] = 	"Molten Core (40)",
		["ZG"] = 	"Zul'Gurub (20)",
		["AQ20"] = 	"Ruins of Ahn'Qiraj (20)",
		["BWL"] = 	"Blackwing Lair (40)",
		["AQ40"] = 	"Temple of Ahn'Qiraj (40)",
		["NAX"] = 	"Naxxramas (40)",
		["WSG"] = 	"Warsong Gulch (PvP)",
		["AB"] = 	"Arathi Basin (PvP)",
		["AV"] = 	"Alterac Valley (PvP)",
		["EOTS"] =  "Eye of the Storm (PvP)",
		["SOTA"] =   "Stand of the Ancients (PvP)",
		["WG"]  =   "Wintergrasp (PvP)",
		["ARENA"] = "Arena (PvP)",
		["MISC"] = 	"Miscellaneous",
		["TRADE"] =	"Trade",
		["DEBUG"] = "DEBUG INFO",
		["BAD"] =	"DEBUG BAD WORDS - REJECTED",
		["BREW"] =  "Brewfest - Coren Direbrew",
		["HOLLOW"] =  "Hallow's End - Headless Horseman",
		}

	local dungeonNamesLocales={
		deDE ={
			["RFC"] = 	"Flammenschlund",
			["DM"] = 	"Die Todesminen",
			["WC"] = 	"Die H??hlen des Wehklagens",
			["SFK"] = 	"Burg Schattenfang",
			["STK"] = 	"Das Verlies",
			["BFD"] = 	"Die Tiefschwarze Grotte",
			["GNO"] = 	"Gnomeregan",
			["RFK"] = 	"Kral der Klingenhauer",
			["SM2"] =	"Scharlachrotes Kloster",
			["SMG"] = 	"Scharlachrotes Kloster: Friedhof",
			["SML"] = 	"Scharlachrotes Kloster: Bibliothek",
			["SMA"] = 	"Scharlachrotes Kloster: Waffenkammer",
			["SMC"] = 	"Scharlachrotes Kloster: Kathedrale",
			["RFD"] = 	"H??gel der Klingenhauer",
			["ULD"] = 	"Uldaman",
			["ZF"] = 	"Zul'Farrak",
			["MAR"] = 	"Maraudon",
			["ST"] = 	"Der Tempel von Atal'Hakkar",
			["BRD"] = 	"Die Schwarzfels-Tiefen",
			["DM2"] = 	"D??sterbruch",
			["DME"] = 	"D??sterbruch: Ost",
			["DMN"] = 	"D??sterbruch: Nord",
			["DMW"] = 	"D??sterbruch: West",
			["STR"] = 	"Stratholme",
			["SCH"] = 	"Scholomance",
			["LBRS"] = 	"Die Untere Schwarzfelsspitze",
			["UBRS"] = 	"Obere Schwarzfelsspitze (10)",
			["RAMPS"] = "H??llenfeuerzitadelle: H??llenfeuerbollwerk",
			["BF"] = 	"H??llenfeuerzitadelle: Der Blutkessel",
			["SP"] = 	"Echsenkessel: Die Sklavenunterk??nfte",
			["UB"] = 	"Echsenkessel: Der Tiefensumpf",
			["MT"] = 	"Auchindoun: Die Managruft",
			["CRYPTS"] = "Auchindoun: Die Auchenaikrypta",
			["SETH"] = 	"Auchindoun: Sethekkhallen",
			["OHB"] = 	"H??hlen der Zeit: Flucht von Durnholde",
			["MECH"] = 	"Festung der St??rme: Die Mechanar",
			["BM"] = 	"H??hlen der Zeit: Der Schwarze Morast",
			["MGT"] = 	"Die Terrasse der Magister",
			["SH"] = 	"H??llenfeuerzitadelle: Die Zerschmetterten Hallen",
			["BOT"] = 	"Festung der St??rme: Botanica",
			["SL"] = 	"Auchindoun: Schattenlabyrinth",
			["SV"] = 	"Echsenkessel: Die Dampfkammer",
			["ARC"] = 	"Festung der St??rme: Die Arcatraz",
			["KARA"] = 	"Karazhan",
			["GL"] = 	"Gruuls Unterschlupf",
			["MAG"] = 	"H??llenfeuerzitadelle: Magtheridons Kammer",
			["SSC"] = 	"Echsenkessel: H??hle des Schlangenschreins",
			["EYE"] = 	"Das Auge des Sturms",
			["ZA"] = 	"Zul-Aman",
			["HYJAL"] = "Schlacht um den Berg Hyjal",
			["BT"] = 	"Der Schwarze Tempel",
			["SWP"] = 	"Sonnenbrunnenplateau",
			["ONY"] = 	"Onyxias Hort (40)",
			["MC"] = 	"Geschmolzener Kern (40)",
			["ZG"] = 	"Zul'Gurub (20)",
			["AQ20"] = 	"Ruinen von Ahn'Qiraj (20)",
			["BWL"] = 	"Pechschwingenhort (40)",
			["AQ40"] = 	"Tempel von Ahn'Qiraj (40)",
			["NAX"] = 	"Naxxramas (40)",
			["WSG"] = 	"Warsongschlucht (PVP)",
			["AV"] = 	"Alteractal (PVP)",
			["AB"] = 	"Arathibecken (PVP)",
			["EOTS"] =  "Auge des Sturms (PvP)",
			["ARENA"] = "Arena (PvP)",
			["MISC"] = 	"Verschiedenes",
			["TRADE"] =	"Handel",

		},
		frFR ={
    ["RFC"] = 	"Gouffre de Ragefeu",
    ["DM"] = 	"Les Mortemines",
    ["WC"] = 	"Cavernes des lamentations",
    ["SFK"] = 	"Donjon d'Ombrecroc",
    ["STK"] = 	"La Prison",
    ["BFD"] = 	"Profondeurs de Brassenoire",
    ["GNO"] = 	"Gnomeregan",
    ["RFK"] = 	"Kraal de Tranchebauge",
    ["SM2"] =	"Monast??re ??carlate",
    ["SMG"] = 	"Monast??re ??carlate: Cimeti??re",
    ["SML"] = 	"Monast??re ??carlate: Biblioth??que",
    ["SMA"] = 	"Monast??re ??carlate: Armurerie",
    ["SMC"] = 	"Monast??re ??carlate: Cath??drale",
    ["RFD"] = 	"Souilles de Tranchebauge",
    ["ULD"] = 	"Uldaman",
    ["ZF"] = 	"Zul'Farrak",
    ["MAR"] = 	"Maraudon",
    ["ST"] = 	"Le temple d'Atal'Hakkar",
    ["BRD"] = 	"Profondeurs de Blackrock",
    ["DM2"] = 	"Hache-tripes",
    ["DME"] = 	"Hache-tripes: Est",
    ["DMN"] = 	"Hache-tripes: Nord",
    ["DMW"] = 	"Hache-tripes: Ouest",
    ["STR"] = 	"Stratholme",
    ["SCH"] = 	"Scholomance",
    ["LBRS"] = 	"Pic Blackrock",
    ["UBRS"] = 	"Pic Blackrock (10)",
    ["RAMPS"] = "Citadelle des Flammes Infernales: Remparts des Flammes infernales",
    ["BF"] = 	"Citadelle des Flammes Infernales: La Fournaise du sang",
    ["SP"] = 	"R??servoir de Glissecroc : Les enclos aux esclaves",
    ["UB"] = 	"R??servoir de Glissecroc : La Basse-tourbi??re",
    ["MT"] = 	"Auchindoun: Tombes-mana",
    ["CRYPTS"] = "Auchindoun: Cryptes Auchena??",
    ["SETH"] = 	"Auchindoun: Les salles des Sethekk",
    ["OHB"] = 	"Grottes du Temps: Contreforts de Hautebrande d'antan",
    ["MECH"] = 	"Donjon de la Temp??te: Le M??chanar",
    ["BM"] = 	"Grottes du Temps: Le Noir Mar??cage",
    ["MGT"] = 	"Terrasse des Magist??res",
    ["SH"] = 	"Citadelle des Flammes Infernales: Les Salles bris??es",
    ["BOT"] = 	"Donjon de la Temp??te: Botanica",
    ["SL"] = 	"Auchindoun: Labyrinthe des ombres",
    ["SV"] = 	"R??servoir de Glissecroc : Le Caveau de la vapeur",
    ["ARC"] = 	"Donjon de la Temp??te: L'Arcatraz",
    ["KARA"] = 	"Karazhan",
    ["GL"] = 	"Repaire de Gruul",
    ["MAG"] = 	"Citadelle des Flammes Infernales: Le repaire de Magtheridon",
    ["SSC"] = 	"R??servoir de Glissecroc : Caverne du sanctuaire du Serpent",
    ["EYE"] = 	"Donjon de la Temp??te : L'Oeil",
    ["ZA"] = 	"Zul-Aman",
    ["HYJAL"] = "Sommet d'Hyjal",
    ["BT"] = 	"Temple noir",
    ["SWP"] = 	"Plateau du Puits de soleil",
    ["ONY"] = 	"Repaire d'Onyxia (40)",
    ["MC"] = 	"C??ur du Magma (40)",
    ["ZG"] = 	"Zul'Gurub (20)",
    ["AQ20"] = 	"Ruines d'Ahn'Qiraj (20)",
    ["BWL"] = 	"Repaire de l'Aile noire (40)",
    ["AQ40"] = 	"Ahn'Qiraj (40)",
    ["NAX"] = 	"Naxxramas (40)",
    ["ARENA"] = "Ar??ne (PvP)",
    ["AB"] = "Bassin d'Arathi (PvP)",
    ["ANK"] = "Ahn'kahet, l'Ancien royaume",
    ["AV"] = "Vall??e d'Alterac (PvP)",
    ["AZN"] = "Azjol-N??rub",
    ["BREW"] = "Fete des brasseurs - Coren Navrebi??re",
    ["CHAMP"] = "L'??preuve du champion",
    ["COS"] = "L'??puration de Stratholme",
    ["DEBUG"] = "DEBUG",
    ["DTK"] = "Donjon de Drak'Tharon",
    ["EOE"] = "L'Oeil de l'??ternit??",
    ["EOTS"] = "L'Oeil du cyclone (PvP)",
    ["FOS"] = "La Forge des ??mes",
    ["GD"] = "Gundrak",
    ["HOL"] = "Les salles de Foudre",
    ["HOLLOW"] = "Sanssaint - Cavalier sans t??te",
    ["HOR"] = "Salles des Reflets",
    ["HOS"] = "Les salles de Pierre",
    ["MISC"] = "Divers",
    ["NEX"] = "Le Nexus",
    ["OCC"] = "L'Oculus",
    ["OS"] = "Le sanctum Obsidien",
    ["POS"] = "Fosse de Saron",
    ["RS"] = "Le sanctum Rubis",
    ["SOTA"] = "Rivage des Anciens (PvP)",
    ["TOTC"] = "L'??preuve du crois??",
    ["TRADE"] = "Commerce",
    ["UK"] = "Donjon d'Utgarde",
    ["ULDAR"] = "Ulduar",
    ["UP"] = "Cime d'Utgarde",
    ["VH"] = "Le fort Pourpre",
    ["VOA"] = "Caveau d'Archavon",
    ["WG"] = "Joug-d'hiver",
    ["WSG"] = "Goulet des Chanteguerres (PvP)", 
		},
		esMX ={
			["RFC"] = 	"Sima ??gnea",
			["DM"] = 	"Las Minas de la Muerte",
			["WC"] = 	"Cuevas de los Lamentos",
			["SFK"] = 	"Castillo de Colmillo Oscuro",
			["STK"] = 	"Las Mazmorras",
			["BFD"] = 	"Cavernas de Brazanegra",
			["GNO"] = 	"Gnomeregan",
			["RFK"] = 	"Horado Rajacieno",
			["SM2"] =	"Monasterio Escarlata",
			["SMG"] = 	"Monasterio Escarlata: Friedhof",
			["SML"] = 	"Monasterio Escarlata: Bibliothek",
			["SMA"] = 	"Monasterio Escarlata: Waffenkammer",
			["SMC"] = 	"Monasterio Escarlata: Kathedrale",
			["RFD"] = 	"Zah??rda Rojocieno",
			["ULD"] = 	"Uldaman",
			["ZF"] = 	"Zul'Farrak",
			["MAR"] = 	"Maraudon",
			["ST"] = 	"El Templo de Atal'Hakkar",
			["BRD"] = 	"Profundidades de Roca Negra	",
			["DM2"] = 	"La Masacre",
			["DME"] = 	"La Masacre: Ost",
			["DMN"] = 	"La Masacre: Nord",
			["DMW"] = 	"La Masacre: West",
			["STR"] = 	"Stratholme",
			["SCH"] = 	"Scholomance",
			["LBRS"] = 	"Cumbre de Roca Negra",
			["UBRS"] = 	"Cumbre de Roca Negra (10)",
			["RAMPS"] = "Hellfire Citadel: Ramparts",
			["BF"] = 	"Hellfire Citadel: Blood Furnace",
			["SP"] = 	"Coilfang Reservoir: Slave Pens",
			["UB"] = 	"Coilfang Reservoir: Underbog",
			["MT"] = 	"Auchindoun: Mana Tombs",
			["CRYPTS"] = "Auchindoun: Auchenai Crypts",
			["SETH"] = 	"Auchindoun: Sethekk Halls",
			["OHB"] = 	"Caverns of Time: Old Hillsbrad",
			["MECH"] = 	"Tempest Keep: The Mechanar",
			["BM"] = 	"Caverns of Time: Black Morass",
			["MGT"] = 	"Magisters' Terrace",
			["SH"] = 	"Hellfire Citadel: Shattered Halls",
			["BOT"] = 	"Tempest Keep: Botanica",
			["SL"] = 	"Auchindoun: Shadow Labyrinth",
			["SV"] = 	"Coilfang Reservoir: Steamvault",
			["ARC"] = 	"Tempest Keep: The Arcatraz",
			["KARA"] = 	"Karazhan",
			["GL"] = 	"Gruul's Lair",
			["MAG"] = 	"Hellfire Citadel: Magtheridon's Lair",
			["SSC"] = 	"Coilfang Reservoir: Serpentshrine Cavern",
			["EYE"] = 	"The Eye",
			["ZA"] = 	"Zul-Aman",
			["HYJAL"] = "The Battle For Mount Hyjal",
			["BT"] = 	"Black Temple",
			["SWP"] = 	"Sunwell Plateau",
			["ONY"] = 	"Guarida de Onyxia (40)",
			["MC"] = 	"N??cleo de Magma (40)",
			["ZG"] = 	"Zul'Gurub (20)",
			["AQ20"] = 	"Ruinas de Ahn'Qiraj (20)",
			["BWL"] = 	"Guarida Alanegra (40)",
			["AQ40"] = 	"Ahn'Qiraj (40)",
			["NAX"] = 	"Naxxramas (40)",
			["ARENA"] = "Arena (PvP)",

		},
		ruRU = {
			["AB"] = "???????????? ?????????? (PvP)",
			["ANK"] = "????'??????????: ???????????? ??????????????????????",
			["AQ20"] = "?????????? ????'???????????? (20)",
			["AQ40"] = "????'?????????? (40)",
			["ARC"] = "???????????????? ????????: ????????????????",
			["ARENA"] = "?????????? (PvP)",
			["AV"] = "???????????????????????? ???????????? (PvP)",
			["AZN"] = "??????????-??????????",
			["BAD"] = "?????????????? ???????????? ?????????? - ????????????????",
			["BF"] = "???????????????? ?????????????? ??????????????: ?????????? ??????????",
			["BFD"] = "???????????????????????? ????????????",
			["BM"] = "???????????? ??????????????: ???????????? ????????",
			["BOT"] = "???????????????? ????????: ????????????????",
			["BRD"] = "?????????????? ???????????? ????????",
			["BREW"] = "???????????????? ?????????????????? - ?????????? ??????????????",
			["BT"] = "???????????? ????????",
			["BWL"] = "???????????? ?????????? ???????? (40)",
			["CHAMP"] = "?????????????????? ????????????????",
			["COS"] = "???????????????? ??????????????????????",
			["CRYPTS"] = "????????????????: ?????????????????????? ????????????????",
			["DEBUG"] = "???????????????????? ?? ????????????????",
			["DM"] = "?????????????? ????????",
			["DM2"] = "?????????????? ??????????",
			["DME"] = "?????????????? ??????????: ????????????",
			["DMN"] = "?????????????? ??????????: ??????????",
			["DMW"] = "?????????????? ??????????: ??????????",
			["DTK"] = "???????????????? ????????'??????????",
			["EOE"] = "?????? ????????????????",
			["EOTS"] = "?????? ???????? (PvP)",
			["EYE"] = "???????????????? ????????: ??????",
			["FOS"] = "?????????? ??????",
			["GD"] = "??????????????",
			["GL"] = "???????????? ????????????",
			["GNO"] = "??????????????????",
			["HOL"] = "?????????????? ????????????",
			["HOLLOW"] = "???????????????? - ?????????????? ?????? ????????????",
			["HOR"] = "???????? ??????????????????",
			["HOS"] = "?????????????? ??????????",
			["HYJAL"] = "???????????? ??????????????: ?????????????? ??????????????",
			["ICC"] = "???????????????? ?????????????? ????????????",
			["KARA"] = "??????????????",
			["LBRS"] = "?????? ?????????????? ???????????? ????????",
			["MAG"] = "???????????????? ?????????????? ??????????????: ???????????? ??????????????????????",
			["MAR"] = "??????????????",
			["MC"] = "???????????????? ?????????? (40)",
			["MECH"] = "???????????????? ????????: ??????????????",
			["MGT"] = "?????????????? ??????????????????",
			["MISC"] = "????????????",
			["MT"] = "????????????????: ???????????????? ????????",
			["NAX"] = "?????????????????? (40)",
			["NAXX"] = "??????????????????",
			["NEX"] = "????????????",
			["OCC"] = "????????????",
			["OHB"] = "???????????? ??????????????: ???????????? ?????????????????? ??????????????????",
			["ONY"] = "???????????? ?????????????? (40)",
			["OS"] = "???????????????????????? ??????????????????",
			["POS"] = "?????? ????????????",
			["RAMPS"] = "???????????????? ?????????????? ??????????????: ????????????????",
			["RFC"] = "???????????????? ????????????????",
			["RFD"] = "?????????????? ????????????????????",
			["RFK"] = "?????????????????? ????????????????????",
			["RS"] = "?????????????????? ??????????????????",
			["SCH"] = "????????????????????",
			["SETH"] = "????????????????: ???????????????????? ????????",
			["SFK"] = "???????????????? ?????????????? ??????????",
			["SH"] = "???????????????? ?????????????? ??????????????: ?????????????????????? ????????",
			["SL"] = "????????????????: ???????????? ????????????????",
			["SM2"] = "?????????????????? ?????????? ????????????",
			["SMA"] = "?????????????????? ?????????? ????????????: ??????????????????",
			["SMC"] = "?????????????????? ?????????? ????????????: ??????????",
			["SMG"] = "?????????????????? ?????????? ????????????: ????????????????",
			["SML"] = "?????????????????? ?????????? ????????????: ????????????????????",
			["SOTA"] = "?????????? ?????????????? (PvP)",
			["SP"] = "?????????????????? ?????????????? ??????????: ??????????????",
			["SSC"] = "?????????????????? ?????????????? ??????????: ?????????????? ??????????????????",
			["ST"] = "???????????????????? ????????",
			["STK"] = "????????????",
			["STR"] = "????????????????????",
			["SV"] = "?????????????????? ?????????????? ??????????: ?????????????? ????????????????????",
			["SWP"] = "?????????? ???????????????????? ??????????????",
			["TOTC"] = "?????????????????? ??????????????????????",
			["TRADE"] = "????????????????",
			["UB"] = "?????????????????? ?????????????? ??????????: ????????????????",
			["UBRS"] = "???????? ?????????????? ???????????? ???????? (10)",
			["UK"] = "???????????????? ????????????",
			["ULD"] = "????????????????",
			["ULDAR"] = "??????????????",
			["UP"] = "?????????????? ????????????",
			["VH"] = "?????????????????????? ????????????????",
			["VOA"] = "?????????? ????????????????",
			["WC"] = "???????????? ????????????????",
			["WG"] = "?????????? ?????????????? ???????? (PvP)",
			["WSG"] = "???????????? ?????????? ?????????? (PvP)",
			["ZA"] = "??????'????????",
			["ZF"] = "??????'????????????",
			["ZG"] = "??????'?????????? (20)",
		},
		zhTW ={
			["RFC"] = 	"????????????",
			["DM"] = 	"????????????",
			["WC"] = 	"????????????",
			["SFK"] = 	"????????????",
			["STK"] = 	"??????",
			["BFD"] = 	"????????????",
			["GNO"] = 	"????????????",
			["RFK"] = 	"????????????",
			["SM2"] =	"???????????????",
			["SMG"] = 	"???????????????: ??????",
			["SML"] = 	"???????????????: ?????????",
			["SMA"] = 	"???????????????: ?????????",
			["SMC"] = 	"???????????????: ?????????",
			["RFD"] = 	"????????????",
			["ULD"] = 	"?????????",
			["ZF"] = 	"???????????????",
			["MAR"] = 	"?????????",
			["ST"] = 	"??????????????????",
			["BRD"] = 	"????????????",
			["DM2"] = 	"????????????",
			["DME"] = 	"????????????: ???",
			["DMN"] = 	"????????????: ???",
			["DMW"] = 	"????????????: ???",
			["STR"] = 	"????????????",
			["SCH"] = 	"????????????",
			["LBRS"] = 	"???????????????",
			["UBRS"] = 	"??????????????? (10)",
			["RAMPS"] = 	"???????????????",
			["BF"] = 	"?????????",
			["SP"] = 	"????????????",
			["UB"] = 	"????????????",
			["MT"] = 	"????????????",
			["CRYPTS"] = 	"???????????????",
			["SETH"] = 	"???????????????",
			["OHB"] = 	"??????????????????????????????",
			["MECH"] = 	"????????????",
			["BM"] = 	"????????????",
			["MGT"] = 	"???????????????",
			["SH"] = 	"????????????",
			["BOT"] = 	"????????????",
			["SL"] = 	"????????????",
			["SV"] = 	"????????????",
			["ARC"] = 	"????????????",
			["KARA"] = 	"????????? (10)",
			["GL"] = 	"??????????????? (25)",
			["MAG"] = 	"????????????????????? (25)",
			["SSC"] = 	"?????????????????? (25)",
			["EYE"] = 	"???????????? (25)",
			["ZA"] = 	"????????? (10)",
			["HYJAL"] = 	"???????????? (25)",
			["BT"] = 	"???????????? (25)",
			["SWP"] = 	"?????????????????? (25)",
			["ONY"] = 	"???????????????????????? (40)",
			["MC"] = 	"???????????? (40)",
			["ZG"] = 	"??????????????? (20)",
			["AQ20"] = 	"??????????????? (20)",
			["BWL"] = 	"???????????? (40)",
			["AQ40"] = 	"????????? (40)",
			["NAX"] = 	"??????????????? (40)",
			["WSG"] = 	"???????????? (PvP)",
			["AB"] = 	"??????????????? (PvP)",
			["AV"] = 	"?????????????????? (PvP)",
			["EOTS"] = 	"???????????? (PvP)",
			["MISC"] = 	"?????????",
			["TRADE"] =	"??????",
		},
		zhCN ={
			["UK"] = 	"??????????????????",
			["NEX"] = 	"??????",
			["AZN"] = 	"??????",
			["ANK"] = 	"???????????????????????????",
			["DTK"] = 	"??????????????????",
			["VH"] = 	"???????????????",
			["GD"] = 	"?????????",
			["HOS"] = 	"????????????",
			["HOL"] = 	"????????????",
			["COS"] = 	"??????????????????",
			["OCC"] = 	"??????",
			["UP"] = 	"??????????????????",
			["FOS"] = 	"????????????",
			["POS"] = 	"????????????",
			["HOR"] = 	"????????????",
			["CHAMP"] = "???????????????",
			["NAXX"] = 	"???????????????80",

			["OS"]   =  "??????????????? ??????",
			["VOA"] = 	"?????????????????????",
			["EOE"] = 	"???????????? ??????",
			["ULDAR"] = "?????????",
			["TOTC"] = 	"??????????????????",
			["RS"] = 	"????????????",
			["ICC"] = 	"????????????",

			["RFC"] = 	"????????????",
			["DM"] = 	"????????????",
			["WC"] = 	"????????????",
			["SFK"] = 	"????????????",
			["STK"] = 	"??????",
			["BFD"] = 	"????????????",
			["GNO"] =  	"????????????" ,
			["RFK"] = 	"????????????",
			["SM2"] =	"???????????????",
			["SMG"] = 	"???????????????: ??????",
			["SML"] = 	"???????????????: ?????????",
			["SMA"] = 	"???????????????: ?????????",
			["SMC"] = 	"???????????????: ??????",
			["RFD"] = 	"????????????",
			["ULD"] = 	"?????????",
			["ZF"] = 	"???????????????",
			["MAR"] = 	"?????????",
			["ST"] = 	"???????????????",
			["BRD"] = 	"????????????",
			["DM2"] = 	"????????????",
			["DME"] = 	"????????????: ???",
			["DMN"] = 	"????????????: ???",
			["DMW"] = 	"????????????: ???",
			["STR"] = 	"????????????",
			["SCH"] = 	"????????????",
			["LBRS"] = 	"???????????????",
			["UBRS"] = 	"??????????????? (10)",
			["RAMPS"] = "???????????????",
			["BF"] = 	"????????????",
			["SP"] = 	"????????????",
			["UB"] = 	"????????????",
			["MT"] = 	"????????????",
			["CRYPTS"] = "???????????????",
			["SETH"] = 	"???????????????",
			["OHB"] = 	"???????????????????????????",
			["MECH"] = 	"?????????",
			["BM"] = 	"????????????",
			["MGT"] = 	"???????????????",
			["SH"] = 	"????????????",
			["BOT"] = 	"?????????",
			["SL"] = 	"????????????",
			["SV"] = 	"????????????",
			["ARC"] = 	"????????????",
			["KARA"] = 	"????????? (10)",
			["GL"] = 	"??????????????? (25)",
			["MAG"] = 	"????????????????????? (25)",
			["SSC"] = 	"???????????? (25)",
			["EYE"] = 	"???????????? (25)",
			["ZA"] = 	"????????? (10)",
			["HYJAL"] = "???????????? (25)",
			["BT"] = 	"???????????? (25)",
			["SWP"] = 	"?????????????????? (25)",
			["ONY"] = 	"???????????????????????? (40)",
			["MC"] = 	"???????????? (40)",
			["ZG"] = 	"??????????????? (20)",
			["AQ20"] = 	"??????????????? (20)",
			["BWL"] = 	"???????????? (40)",
			["AQ40"] = 	"????????? (40)",
			["NAX"] = 	"??????????????? (40)",
			["WSG"] = 	"???????????? (PvP)",
			["AB"] = 	"??????????????? (PvP)",
			["AV"] = 	"?????????????????? (PvP)",
			["EOTS"] = 	"???????????? (PvP)",
			["MISC"] = 	"?????????",
			["TRADE"] =	"??????",
		},
	}



	local dungeonNames = dungeonNamesLocales[GetLocale()] or {}

	if GroupBulletinBoardDB and GroupBulletinBoardDB.CustomLocalesDungeon and type(GroupBulletinBoardDB.CustomLocalesDungeon) == "table" then
		for key,value in pairs(GroupBulletinBoardDB.CustomLocalesDungeon) do
			if value~=nil and value ~="" then
				dungeonNames[key.."_org"]=dungeonNames[key] or DefaultEnGB[key]
				dungeonNames[key]=value
			end
		end
	end


	setmetatable(dungeonNames, {__index = DefaultEnGB})

	dungeonNames["DEADMINES"]=dungeonNames["DM"]

	return dungeonNames
end

local function Union ( a, b )
    local result = {}
    for k,v in pairs ( a ) do
        result[k] = v
    end
    for k,v in pairs ( b ) do
		result[k] = v
    end
    return result
end

GBB.VanillaDungeonLevels ={
	["RFC"] = 	{13,18}, ["DM"] = 	{18,23}, ["WC"] = 	{15,25}, ["SFK"] = 	{22,30}, ["STK"] = 	{22,30}, ["BFD"] = 	{24,32},
	["GNO"] = 	{29,38}, ["RFK"] = 	{30,40}, ["SMG"] = 	{28,38}, ["SML"] = 	{29,39}, ["SMA"] = 	{32,42}, ["SMC"] = 	{35,45},
	["RFD"] = 	{40,50}, ["ULD"] = 	{42,52}, ["ZF"] = 	{44,54}, ["MAR"] = 	{46,55}, ["ST"] = 	{50,60}, ["BRD"] = 	{52,60},
	["LBRS"] = 	{55,60}, ["DME"] = 	{58,60}, ["DMN"] = 	{58,60}, ["DMW"] = 	{58,60}, ["STR"] = 	{58,60}, ["SCH"] = 	{58,60},
	["UBRS"] = 	{58,60}, ["MC"] = 	{60,60}, ["ZG"] = 	{60,60}, ["AQ20"]= 	{60,60}, ["BWL"] = {60,60},
	["AQ40"] = 	{60,60}, ["NAX"] = 	{60,60},
	["MISC"]= {0,100},
	["DEBUG"] = {0,100}, ["BAD"] =	{0,100}, ["TRADE"]=	{0,100}, ["SM2"] =  {28,42}, ["DM2"] =	{58,60}, ["DEADMINES"]={18,23},
}

GBB.PostTbcDungeonLevels = {
	["RFC"] = 	{13,20}, ["DM"] = 	{16,24}, ["WC"] = 	{16,24}, ["SFK"] = 	{17,25}, ["STK"] = 	{21,29}, ["BFD"] = 	{20,28},
	["GNO"] = 	{24,40}, ["RFK"] = 	{23,31}, ["SMG"] = 	{28,34}, ["SML"] = 	{30,38}, ["SMA"] = 	{32,42}, ["SMC"] = 	{35,44},
	["RFD"] = 	{33,41}, ["ULD"] = 	{36,44}, ["ZF"] = 	{42,50}, ["MAR"] = 	{40,52}, ["ST"] = 	{45,54}, ["BRD"] = 	{48,60},
	["LBRS"] = 	{54,60}, ["DME"] = 	{54,61}, ["DMN"] = 	{54,61}, ["DMW"] = 	{54,61}, ["STR"] = 	{56,61}, ["SCH"] = 	{56,61},
	["UBRS"] = 	{53,61}, ["MC"] = 	{60,60}, ["ZG"] = 	{60,60}, ["AQ20"]= 	{60,60}, ["BWL"] = {60,60},
	["AQ40"] = 	{60,60}, ["NAX"] = 	{60,60},
	["MISC"]= {0,100},
	["DEBUG"] = {0,100}, ["BAD"] =	{0,100}, ["TRADE"]=	{0,100}, ["SM2"] =  {28,42}, ["DM2"] =	{58,60}, ["DEADMINES"]={16,24},
}


GBB.TbcDungeonLevels = {
	["RAMPS"] =  {60,62}, 	["BF"] = 	 {61,63},     ["SP"] = 	 {62,64},    ["UB"] = 	 {63,65},     ["MT"] = 	 {64,66},     ["CRYPTS"] = {65,67},
	["SETH"] =   {67,69},  	["OHB"] = 	 {66,68},     ["MECH"] =   {69,70},    ["BM"] =      {69,70},    ["MGT"] =	 {70,70},    ["SH"] =	 {70,70},
	["BOT"] =    {70,70},    ["SL"] = 	 {70,70},    ["SV"] =     {70,70},   ["ARC"] = 	 {70,70},    ["KARA"] = 	 {70,70},    ["GL"] = 	 {70,70},
	["MAG"] =    {70,70},    ["SSC"] =    {70,70}, 	["EYE"] =    {70,70},   ["ZA"] = 	 {70,70},    ["HYJAL"] =  {70,70}, 	["BT"] =     {70,70},
	["SWP"] =    {70,70},
}

GBB.PvpLevels = {
	["WSG"] = 	{10,70}, ["AB"] = 	{20,70}, ["AV"] = 	{51,70},   ["WG"] = {80,80}, ["SOTA"] = {80,80},  ["EOTS"] =   {15,70},   ["ARENA"] = {70,80},
}

GBB.WotlkDungeonLevels = {
	["UK"] =    {68,80},    ["NEX"] =    {69,80},    ["AZN"] =    {70,80},    ["ANK"] =    {71,80},    ["DTK"] =    {72,80},    ["VH"] =    {73,80},
	["GD"] =    {74,80},    ["HOS"] =    {75,80},    ["HOL"] =    {76,80},    ["COS"] =    {78,80},    ["OCC"] =    {77,80},    ["UP"] =    {77,80},
	["FOS"] =    {80,80},   ["POS"] =    {80,80},    ["HOR"] =    {80,80},    ["CHAMP"] =  {78,80},    ["OS"] =    {80,80},    ["VOA"] =    {80,80},
	["EOE"] =    {80,80},   ["ULDAR"] =  {80,80},    ["TOTC"] =     {80,80},    ["RS"] =     {80,80},    ["ICC"] =    {80,80},    ["ONY"] =    {80,80},
	["NAXX"] =   {80,80},   ["BREW"] = {65,70},      ["HOLLOW"] = {65,70},
}

GBB.WotlkDungeonNames = {
	"UK", "NEX", "AZN", "ANK", "DTK", "VH", "GD", "HOS", "HOL", "COS",
	"OCC", "UP", "FOS", "POS", "HOR", "CHAMP", "OS", "VOA", "EOE", "ULDAR",
	"TOTC", "RS", "ICC", "ONY", "NAXX"
}

GBB.TbcDungeonNames = {
	"RAMPS", "BF", "SH", "MAG", "SP", "UB", "SV", "SSC", "MT", "CRYPTS",
	"SETH", "SL", "OHB", "BM", "MECH", "BOT", "ARC", "EYE", "MGT", "KARA",
	"GL", "ZA", "HYJAL", "BT", "SWP",
}

GBB.VanillDungeonNames  = {
	"RFC", "WC" , "DM" , "SFK", "STK", "BFD", "GNO",
    "RFK", "SMG", "SML", "SMA", "SMC", "RFD", "ULD",
    "ZF", "MAR", "ST" , "BRD", "LBRS", "DME", "DMN",
    "DMW", "STR", "SCH", "UBRS", "MC", "ZG",
    "AQ20", "BWL", "AQ40", "NAX",
}


GBB.PvpNames = {
	"WSG", "AB", "AV", "EOTS", "WG", "SOTA", "ARENA",
}

GBB.Misc = {"MISC", "TRADE",}

GBB.DebugNames = {
	"DEBUG", "BAD", "NIL",
}

GBB.Raids = {
	"ONY", "MC", "ZG", "AQ20", "BWL", "AQ40", "NAX",
	"KARA", "GL", "MAG", "SSC", "EYE", "ZA", "HYJAL",
	"BT", "SWP", "ARENA", "WSG", "AV", "AB", "EOTS",
	"WG", "SOTA", "BREW", "HOLLOW", "OS", "VOA", "EOE",
	"ULDAR", "TOTC", "RS", "ICC", "NAXX",
}

GBB.Seasonal = {
    ["BREW"] = { startDate = "09/20", endDate = "10/06"},
	["HOLLOW"] = { startDate = "10/18", endDate = "11/01"}
}

GBB.SeasonalActiveEvents = {}
GBB.Events = getSeasonalDungeons()

function GBB.GetRaids()
	local arr = {}
	for _, v in pairs (GBB.Raids) do
		arr[v] = 1
	end
	return arr
end

-- Needed because Lua sucks, Blizzard switch to Python please
-- Takes in a list of dungeon lists, it will then concatenate the lists into a single list
-- it will put the dungeons in an order and give them a value incremental value that can be used for sorting later
-- ie one list "Foo" which contains "Bar" and "FooBar" and a second list "BarFoo" which contains "BarBar"
-- the output would be single list with "Bar" = 1, "FooBar" = 2, "BarFoo" = 3, "BarBar" = 4
local function ConcatenateLists(Names)
	local result = {}
	local index = 1
	for k, nameLists in pairs (Names) do
		for _, v in pairs(nameLists) do
			result[v] = index
			index = index + 1
		end
	end
	return result, index
end

function GBB.GetDungeonSort()
	for eventName, eventData in pairs(GBB.Seasonal) do
        if GBB.Tool.InDateRange(eventData.startDate, eventData.endDate) then
			table.insert(GBB.WotlkDungeonNames, 1, eventName)
		else
			table.insert(GBB.DebugNames, 1, eventName)
		end
    end

	local dungeonOrder = { GBB.VanillDungeonNames, GBB.TbcDungeonNames, GBB.WotlkDungeonNames, GBB.PvpNames, GBB.Misc, GBB.DebugNames}

	-- Why does Lua not having a fucking size function
	 local vanillaDungeonSize = 0
	 for _, _ in pairs(GBB.VanillDungeonNames) do
		vanillaDungeonSize = vanillaDungeonSize + 1
	 end

	 local tbcDungeonSize = 0
	 for _, _ in pairs(GBB.TbcDungeonNames) do
		tbcDungeonSize = tbcDungeonSize + 1
	 end

	local debugSize = 0
	for _, _ in pairs(GBB.DebugNames) do
		debugSize = debugSize+1
	end


	local tmp_dsort, concatenatedSize = ConcatenateLists(dungeonOrder)
	local dungeonSort = {}

	GBB.TBCDUNGEONSTART = vanillaDungeonSize + 1
	GBB.MAXDUNGEON = vanillaDungeonSize
	GBB.TBCMAXDUNGEON = vanillaDungeonSize  + tbcDungeonSize
	GBB.WOTLKDUNGEONSTART = GBB.TBCMAXDUNGEON + 1
	GBB.WOTLKMAXDUNGEON = concatenatedSize - debugSize - 1

	for dungeon,nb in pairs(tmp_dsort) do
		dungeonSort[nb]=dungeon
		dungeonSort[dungeon]=nb
	end

	-- Need to do this because I don't know I am too lazy to debug the use of SM2, DM2, and DEADMINES
	dungeonSort["SM2"] = 10.5
	dungeonSort["DM2"] = 19.5
	dungeonSort["DEADMINES"] = 99

	return dungeonSort
end

local function DetermineVanillDungeonRange()

	return GBB.PostTbcDungeonLevels

end

GBB.dungeonLevel = Union(Union(Union(DetermineVanillDungeonRange(), GBB.TbcDungeonLevels), GBB.WotlkDungeonLevels), GBB.PvpLevels)
