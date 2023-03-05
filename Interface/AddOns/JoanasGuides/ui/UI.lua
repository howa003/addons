--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

UI = { }

local components = { }
local updateComponents = { }
local frame
local isDirty
local elapsed

function UI.Update(elapsed_)
	elapsed = elapsed_
	for _, component in ipairs(updateComponents) do
		if (isDirty) then component:MarkDirty() end
		component.Update()
	end
	elapsed = 0
	isDirty = nil
end

function UI.Add(component)
	table.insert(components, component)
	if (component.name) then
		components[component.name] = component
	end
	if (component.Update) then
		table.insert(updateComponents, component)
	end
end

function UI.GetElapsed()
	return elapsed
end

function UI.Init()
	frame = CreateFrame("Frame")
	for _, component in ipairs(components) do
		if (component.Init) then
			component.Init(components)
		end
	end
	--todo: remove shims
	local frame = GetGuideFrame()
	frame.Header = components.Header.frame
	frame.StepID = components.HeaderStep.text
	frame.Settings = components.HeaderSettingsButton.frame
	frame.BackButton = components.HeaderBackButton.frame
	frame.NextButton = components.HeaderNextButton.frame
end

function UI.IsDirty()
	return isDirty
end

function UI.MarkDirty()
	isDirty = true
end

function UI.IsTaskGroupDimmed(taskGroup)
	if (Guide.IsStepNodeCompleted(taskGroup.step)) then
		return true
	elseif (not taskGroup.optionalPassed) then
		return false
	elseif (Guide.IsStepNodeCompleted(taskGroup)) then
		if (taskGroup.completed) then return true end
		for _, task in ipairs(taskGroup) do
			if (task.conditionPassed) then
				if (GetTaskType(task):IsDimmable(task)) then
					return true
				end
			end
		end
	end
	return false
end