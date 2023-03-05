--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local context = { }
local functionBase = "return %s"

function CheckCondition(obj)
	if (type(obj) ~= "table" or not obj.condition) then return true end
	local func = loadstring(functionBase:format(obj.condition))
	setfenv(func, context)
	return (func() == true)
end

function CheckCompleted(obj)
	if (type(obj) ~= "table" or not obj.completed) then return nil end
	local func = loadstring(functionBase:format(obj.completed))
	setfenv(func, context)
	return (func() == true)
end

local REP_LEVELS = {
	UNKNOWN = 0,
	HATED = 1,
	HOSTILE = 2,
	UNFRIENDLY = 3,
	NEUTRAL = 4,
	FRIENDLY = 5,
	HONORED = 6,
	REVERED = 7,
	EXALTED = 8,
}

local QUEST = { }

setmetatable(QUEST, {
	__index = function(_, key)
		return QuestStatus.GetQuestStatus(key)
	end
})

local ITEM = { }

setmetatable(ITEM, {
	__index = function(_, key)
		return GetItemCount(key, false)
	end
})

local REP = { }

setmetatable(REP, {
	__index = function(_, key)
		local _, _, standingId = GetFactionInfoByID(key)
		if (not standingID) then return REP_LEVELS.UNKNOWN end
		return standingId
	end
})

function Condition_ResetGuides()
	for _, guideInfo in ipairs(GuideInfos) do
		local moduleInfo = GuideModules.GetModule(guideInfo.moduleID)
		if (moduleInfo and moduleInfo.installed and moduleInfo.compatible) then
			context[guideInfo.guideID] = true
		end
	end
end

function Condition_OnAddonLoad()
	local _, playerClass = UnitClass("Player")
	context["PHASE"] = 6 -- default phase
	if (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
		if (C_LFGList.IsLookingForGroupEnabled()) then
			context["SOM"] = true
			context["PHASE"] = 4
		else
			context["ERA"] = true
		end
	elseif (WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC) then
		context["BCC"] = true
	end
	context[playerClass] = true
	Condition_ResetGuides()
	context["QUEST"] = QUEST
	context["ITEM"] = ITEM
	for k, v in pairs(QuestStatus.status) do
		context[k] = v
	end
	for repLevel, value in pairs(REP_LEVELS) do
		context[repLevel] = value
	end
	context["REP"] = REP
	local playerFaction = UnitFactionGroup("player")
	context[string.upper(playerFaction)] = true
	local _, playerRace = UnitRace("player")
	context[string.upper(playerRace)] = true
end
