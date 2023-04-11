--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "level",
	dimmable = true,
	--todo: Choose an icon for level tasks
	incompleteIcon = ICON_LEARN_TAXI
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	return UnitLevel("player") >= task.level
end

function TaskType:RenderFunc(task, container)
	container.text:SetShown(true)
	container.text:SetText(L["Reach level |C%s%d|r before continuing"]:format(YELLOW, task.level))
end

RegisterTaskType(TaskType)
