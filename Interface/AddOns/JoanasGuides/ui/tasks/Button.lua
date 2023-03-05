--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local TaskType = Mixin({
	type = "button"
}, TaskTypeMixin)

function TaskType:IsCompletedFunc()
	return false
end

function TaskType:RenderFunc(task, container)
	container.button:SetShown(true)
	container.button:SetText(task.button)
	if (task.guide) then
		container.button:SetScript("OnClick", function()
			Guide.SetGuide(task.guide, task.goto)
		end)
	elseif (task.goto) then
		container.button:SetScript("OnClick", function()
			Guide.GotoBookmark(task.goto)
		end)
	end
end

RegisterTaskType(TaskType)
