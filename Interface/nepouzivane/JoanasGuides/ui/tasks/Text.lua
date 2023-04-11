--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "text",
}, TaskTypeMixin)

function TaskType:RenderFunc(task, container)
	container.text:SetShown(true)
	container.text:SetIndentedWordWrap(false)
	container.text:SetText(task.text)
end

RegisterTaskType(TaskType)
