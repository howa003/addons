--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "turnin",
	dimmable = true,
	compactable = true,
	incompleteIcon = ICON_QUEST_TURNIN
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	return IsQuestTurnedIn(task.turnin)
end

function TaskType:RenderFunc(task, container)
	local name = Names.GetName(C_QuestLog.GetQuestInfo, task.turnin)
	container.text:SetShown(true)
	container.text:SetText(L["Turn in: |C%s%s|r"]:format(GOLD, name))
end

RegisterTaskType(TaskType)
