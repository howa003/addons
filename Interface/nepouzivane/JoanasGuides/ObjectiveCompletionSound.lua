--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local eventFrame = CreateFrame("Frame")

local questLog

local function OnEvent()
	local questIndex = 1
	local updatedQuestLog = { }
	while(true) do
		local questLogTitleText, _, _, _, _, isComplete, _, questID = GetQuestLogTitle(questIndex)
		if (questLogTitleText == nil) then
			break
		end
		if (questID ~= 0) then
			local quest = {
				complete = isComplete == 1 or nil
			}
			updatedQuestLog[questID] = quest
			if (not isComplete) then
				local objectives = C_QuestLog.GetQuestObjectives(questID)
				if (objectives) then
					quest.objectives = objectives
				end
			end
		end
		questIndex = questIndex + 1
	end
	if (SavedVariables and SavedVariables.objectiveCompletionSound) then
		local playSound = false
		if (questLog) then
			for questID, quest in pairs(updatedQuestLog) do
				local oldQuest = questLog[questID]
				if (oldQuest and not oldQuest.complete) then
					if (quest.complete) then
						playSound = true
						break
					end
					if (oldQuest.objectives and quest.objectives) then
						for idx, objective in ipairs(quest.objectives) do
							local oldObjective = oldQuest.objectives[idx]
							if (oldObjective and not oldObjective.finished and objective.finished) then
								playSound = true
								break
							end
						end
						if (playSound) then
							break
						end
					end
				end
			end
		end
		if (playSound) then
			local playerFaction = UnitFactionGroup("player")
			PlaySound(playerFaction == "Horde" and 6199 or 6199)
		end
	end
	questLog = updatedQuestLog
end

function SetObjectiveCompletionSoundEnabled(enabled)
	SavedVariables.objectiveCompletionSound = enabled
end

function IsObjectiveCompletionSoundEnabled()
	return SavedVariables.objectiveCompletionSound
end

eventFrame:RegisterEvent("QUEST_LOG_UPDATE")

eventFrame:SetScript("OnEvent", OnEvent)
