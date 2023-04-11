--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local questNameLUT = { }
local questIDsLUT = { }
local questAcceptLimitsLUT = { }
local questTurninLimitsLUT = { }
local EMPTY = { }
local isDirty = false

local IsAutoAcceptEligible, IsAutoTurninEligible, IsAutoQuestEligible

function IsAutoAcceptEligible(questID)
	return IsAutoQuestEligible(questAcceptLimitsLUT, questID)
end

function IsAutoQuestEligible(LUT, questID)
	local questLimits = LUT[questID]
	local currentStep = Guide.GetCurrentStep()
	if (questLimits and questLimits["NOAUTO"]) then
		return false
	end
	-- only accept the quest when the quest is not limited or the quest is limited to the current step
	if (not (questLimits and not (currentStep and questLimits[currentStep.id]))) then
		return true
	end
	return false
end

function IsAutoTurninEligible(questID)
	if (IsQuestCompleted(questID) and not IsQuestTurnedIn(questID)) then
		return IsAutoQuestEligible(questTurninLimitsLUT, questID)
	end
	return false
end

local function OnEvent(_, event, ...)
	-- Retry retrieving quest names for the questIDs present in the LUTs
	if (isDirty) then
		isDirty = false
		for questID, questName in pairs(questNameLUT) do
			if (not questName) then
				questName = C_QuestLog.GetQuestInfo(questID)
				if (questName) then
					questNameLUT[questID] = questName
					questIDsLUT[questName] = questIDsLUT[questName] or { }
					questIDsLUT[questName][questID] = true
				else
					questNameLUT[questID] = false
					isDirty = true
				end
			end
		end
	end

	-- Remove any completed quests from the LUTs
	local completedQuests = GetQuestsCompleted()
	for questID in pairs(questNameLUT) do
		if (completedQuests[questID]) then
			local questName = questNameLUT[questID]
			questNameLUT[questID] = nil
			local questIDs = questIDsLUT[questName]
			if (questIDs) then
				questIDs[questID] = nil
				if (not next(questIDs)) then
					questIDsLUT[questName] = nil
				end
			end
		end
	end
	for _, limitLUT in ipairs({ questAcceptLimitsLUT, questTurninLimitsLUT }) do
		for questID in pairs(limitLUT) do
			if (completedQuests[questID]) then
				limitLUT[questID] = nil
			end
		end
	end

	if (SavedVariables.autoquests) then
		if (event == "QUEST_DETAIL") then
			local questID = GetQuestID()
			if (questNameLUT[questID] ~= nil) then
				if (IsAutoAcceptEligible(questID)) then AcceptQuest() end
			end
			return
		end

		if (event == "GOSSIP_SHOW") then
			local availableQuests = { GetGossipAvailableQuests() }
			for i = 1, #availableQuests, 7 do
				for questID in pairs(questIDsLUT[availableQuests[i]] or EMPTY) do
					if (IsAutoAcceptEligible(questID)) then
						SelectGossipAvailableQuest((i + 6) / 7)
						return
					end
				end
			end
			local activeQuests = { GetGossipActiveQuests() }
			for i = 1, #activeQuests, 6 do
				for questID in pairs(questIDsLUT[GetActiveTitle(i)] or EMPTY) do
					if (IsAutoTurninEligible(questID)) then SelectActiveQuest(i) return end
				end
				for questID in pairs(questIDsLUT[activeQuests[i]] or EMPTY) do
					if (IsAutoTurninEligible(questID)) then SelectGossipActiveQuest((i + 5) / 6) return end
				end
			end
			return
		end

		if (event == "QUEST_GREETING") then
			local numAvailableQuests = GetNumAvailableQuests()
			for i = 1, numAvailableQuests do
				for questID in pairs(questIDsLUT[GetAvailableTitle(i)] or EMPTY) do
					if (IsAutoAcceptEligible(questID)) then SelectAvailableQuest(i) return end
				end
			end
			local numActiveQuests = GetNumActiveQuests()
			for i = 1, numActiveQuests do
				for questID in pairs(questIDsLUT[GetActiveTitle(i)] or EMPTY) do
					if (IsAutoTurninEligible(questID)) then SelectActiveQuest(i) return end
				end
			end
			return
		end

		if (event == "QUEST_PROGRESS") then
			if (IsAutoTurninEligible(GetQuestID()) and IsQuestCompletable()) then
				CompleteQuest()
			end
		end

		if (event == "QUEST_COMPLETE") then
			local numQuestChoices = GetNumQuestChoices()
			if (IsAutoTurninEligible(GetQuestID()) and numQuestChoices <= 0) then
				GetQuestReward(numQuestChoices)
			end
			return
		end
	end
end

function ClearAutoQuests()
	questNameLUT = { }
	questIDsLUT = { }
	isDirty = false
end

function IsAutoQuestsEnabled()
	return SavedVariables.autoquests
end

function LoadAutoQuests(guide)
	questAcceptLimitsLUT = { }
	questTurninLimitsLUT = { }
	for _, step in ipairs(guide) do
		for _, taskGroup in ipairs(step) do
			for _, task in ipairs(taskGroup) do
				local questID
				local limitsLUT
				if (task.accept) then
					questID = task.accept
					limitsLUT = questAcceptLimitsLUT
				elseif (task.turnin) then
					questID = task.turnin
					limitsLUT = questTurninLimitsLUT
				end
				if (questID) then
					local questName = C_QuestLog.GetQuestInfo(questID)
					if (questName) then
						questNameLUT[questID] = questName
						questIDsLUT[questName] = questIDsLUT[questName] or { }
						questIDsLUT[questName][questID] = true
					else
						questNameLUT[questID] = false
						isDirty = true
					end
					if (task.limit == true) then
						limitsLUT[questID] = limitsLUT[questID] or { }
						limitsLUT[questID][step.id] = true
					end
					if (task.auto == false) then
						limitsLUT[questID] = limitsLUT[questID] or { }
						limitsLUT[questID]["NOAUTO"] = true
					end
				end
			end
		end
	end
end

function SetAutoQuestsEnabled(flag)
	SavedVariables.autoquests = flag
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("GOSSIP_SHOW")
eventFrame:RegisterEvent("QUEST_ACCEPT_CONFIRM")
eventFrame:RegisterEvent("QUEST_AUTOCOMPLETE")
eventFrame:RegisterEvent("QUEST_COMPLETE")
eventFrame:RegisterEvent("QUEST_DETAIL")
eventFrame:RegisterEvent("QUEST_FINISHED")
eventFrame:RegisterEvent("QUEST_GREETING")
eventFrame:RegisterEvent("QUEST_PROGRESS")
eventFrame:SetScript("OnEvent", OnEvent)
