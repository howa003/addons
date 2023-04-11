--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "sethearthstone",
	dimmable = true,
	incompleteIcon = ICON_SET_HEARTHSTONE
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	return GetBindLocation() == C_Map.GetAreaInfo(task.sethearthstone)
end

function TaskType:RenderFunc(task, container)
	local name = Names.GetName(C_Map.GetAreaInfo, task.sethearthstone)
	container.text:SetShown(true)
	container.text:SetText(L["Make |C%s%s|r your new home"]:format(GOLD, name))
end

RegisterTaskType(TaskType)
