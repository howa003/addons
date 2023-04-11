--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local taskTypes = { }

TaskTypeMixin = {
	GetType = function(self)
		return self.type
	end
}

function TaskTypeMixin:IsCompleted(task)
	if (self.IsCompletedFunc) then
		return self:IsCompletedFunc(task)
	end
	return true
end

function TaskTypeMixin:IsDimmable(task)
	return (task.completed and true) or self.dimmable
end

function TaskTypeMixin:IsOptional(task)
	return task.optional or false
end

function TaskTypeMixin:Render(task, container)
	container.isDirty = nil
	container.task = task
	if (self.compactable) then
		container.compactable = true
	end
	container.text:Hide()
	container.button:Hide()
	for _, taskDetailContainer in ipairs(container.taskDetailContainers) do
		taskDetailContainer.text:Hide()
		taskDetailContainer.icon:Hide()
	end
	self:RenderFunc(task, container)
	local completed = Guide.IsStepNodeCompleted(task)
	UI.SetIconTexture(
			container.icon,
			self.incompleteIcon and (completed and ICON_COMPLETE or self.incompleteIcon))
end

function TaskTypeMixin:RenderFunc(task, container)
	container.text:SetText("Render not defined for " .. self:GetType())
	container.text:Show()
end

function GetTaskType(task)
	for k, v in pairs(taskTypes) do
		if (task[k]) then return v end
	end
end

function RegisterTaskType(taskType)
	taskTypes[taskType.type] = taskType
end
