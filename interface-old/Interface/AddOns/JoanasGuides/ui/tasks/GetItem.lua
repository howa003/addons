--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "getitem",
	dimmable = true,
	incompleteIcon = ICON_GET_ITEM
}, TaskTypeMixin)

function TaskType:IsCompletedFunc(task)
	if (task.questid and QuestStatus.GetQuestStatus(task.questid) >= QuestStatus.status.COMPLETED) then
		return true
	end
	return GetItemCount(task.getitem, false) >= ((task.quantity ~= nil) and task.quantity or 1)
end

function TaskType:RenderFunc(task, container)
	local name = Names.GetName(GetItemInfo, task.getitem)
	local quantity = task.quantity or 1
	local owned = GetItemCount(task.getitem, false)
	container.text:SetShown(true)
	container.text:SetText(L["Get %s/%s |cFFE36EE4%s|r "]:format((owned < quantity) and owned or quantity , quantity, name))
end

RegisterTaskType(TaskType)
