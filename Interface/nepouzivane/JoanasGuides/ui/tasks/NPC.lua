--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "npc",
}, TaskTypeMixin)

function TaskType:RenderFunc(task, container)
	local name = Names.GetName(GetCreatureName, task.npc)
	container.text:SetShown(true)
	container.text:SetText(L["Speak to |cFFE36EE4%s|r"]:format(name))
end

RegisterTaskType(TaskType)
