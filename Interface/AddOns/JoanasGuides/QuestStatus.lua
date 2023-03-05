--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

QuestStatus = { }

local TURNEDIN = 3
local COMPLETED = 2
local ACCEPTED = 1
local NONE = 0
local FAILED = -1

function QuestStatus.GetQuestStatus(questID)
	if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then return TURNEDIN end
	if (not C_QuestLog.IsOnQuest(questID)) then return NONE end
	local questObjectives = C_QuestLog.GetQuestObjectives(questID)
	local questIndex = 1
	while(true) do
		local questLogTitleText, _, _, _, _, isComplete, _, _questID, startEvent = GetQuestLogTitle(questIndex)
		if (questLogTitleText == nil) then return NONE end -- should never hit this
		if (questID == _questID) then
			if (isComplete) then
				if (isComplete == -1) then return FAILED end
				return COMPLETED
			end
			return (startEvent or #questObjectives > 0) and ACCEPTED or COMPLETED
		end
		questIndex = questIndex + 1
	end
end

QuestStatus.status = {
	TURNEDIN = TURNEDIN,
	COMPLETED = COMPLETED,
	ACCEPTED = ACCEPTED,
	NONE = NONE,
	FAILED = FAILED
}
