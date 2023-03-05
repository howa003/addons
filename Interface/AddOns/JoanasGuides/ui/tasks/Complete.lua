--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "complete",
	taskPrefix = L["Do: |C%s%s|r"],
	taskColor = BLUE,
	incompleteIcon = ICON_DO_QUEST
}, DoQuestMixin)

RegisterTaskType(TaskType)
