--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "accept",
	dimmable = true,
	compactable = true,
	incompleteIcon = ICON_QUEST_ACCEPT
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	return IsQuestAccepted(task.accept)
end

function TaskType:RenderFunc(task, container)
	local name = Names.GetName(C_QuestLog.GetQuestInfo, task.accept)
	container.text:SetShown(true)
	container.text:SetText(L["Accept: |C%s%s|r"]:format(YELLOW, name))
end

RegisterTaskType(TaskType)
