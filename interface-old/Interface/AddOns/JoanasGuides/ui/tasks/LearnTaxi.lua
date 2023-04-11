--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "learntaxi",
	dimmable = true,
	incompleteIcon = ICON_LEARN_TAXI
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	return HasTaxi(task.learntaxi)
end

function TaskType:RenderFunc(task, container)
	local name
	if (task.fromnpc) then
		name = Names.GetName(GetCreatureName, task.fromnpc)
	else
		name = Names.GetName(GetTaxiName, task.learntaxi)
	end
	container.text:SetShown(true)
	if (task.fromnpc) then
		container.text:SetText(L["Talk to |C%s%s|r and get the flight path"]:format(GOLD, name))
	else
		container.text:SetText(L["Get the |C%s%s|r flight path"]:format(GOLD, name))
	end
end

RegisterTaskType(TaskType)
