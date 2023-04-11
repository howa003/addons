--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("TaskContainers")

local taskDetailContainers

local CreateTaskContainer, GetTaskContainersHeight, OnHyperlinkClick, SetTaskContainerShown, UpdateTaskContainer,
	UpdateAllTaskContainers

function CreateTaskContainer(parent, renderFrame)
	local taskContainer = { }
	taskContainer.Update = UpdateTaskContainer
	taskContainer.parent = parent
	local frame = CreateFrame("Frame", nil, renderFrame)
	frame:SetHeight(20)
	frame:SetHyperlinksEnabled(true)
	frame:SetScript("OnHyperlinkClick", OnHyperlinkClick)
	taskContainer.icon = CreateFrame("Frame", nil, frame)
	taskContainer.icon:SetSize(1, ICON_SIZE)
	taskContainer.icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	taskContainer.icon:Hide()
	taskContainer.icon.texture = taskContainer.icon:CreateTexture()
	taskContainer.icon.texture:SetPoint("CENTER")
	taskContainer.text = frame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	taskContainer.text:SetJustifyH("LEFT")
	taskContainer.text:SetPoint("TOPLEFT", taskContainer.icon, "TOPRIGHT", 0, 0)
	taskContainer.text:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
	taskContainer.taskDetailContainers = taskDetailContainers.CreateFactory(taskContainer)
	taskContainer.button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	taskContainer.button:SetPoint("BOTTOM", 0, 6)
	taskContainer.button:SetPoint("LEFT", 0, 0)
	taskContainer.button:SetPoint("RIGHT", -7, 0)
	taskContainer.button:Hide()
	taskContainer.SetShown = SetTaskContainerShown
	taskContainer.frame = frame
	taskContainer.renderFrame = renderFrame
	return taskContainer
end

function GetTaskContainersHeight(self)
	local height = 19
	for idx = 1, math.max(#self) do
		local taskContainerFrame = self[idx].frame
		if (taskContainerFrame:IsShown()) then
			height = height + taskContainerFrame:GetHeight()
		end
	end
	return height
end

function OnHyperlinkClick(_, link)
	local linkType, arg1, arg2, arg3, arg4 = strsplit(":", link);
	if (linkType == "image") then
		ShowImage("Interface/AddOns/JoanasGuides/images/" .. arg1)
	elseif (linkType == "waypoint") then
		SetWaypoint(tonumber(arg1), tonumber(arg2) / 100, tonumber(arg3) / 100, arg4)
	end
end

function SetTaskContainerShown(self, shown)
	local frame = self.frame
	frame:ClearAllPoints()
	local hasPrevious = self:HasPrevious()
	if (shown) then
		frame:SetPoint(
				"TOPLEFT",
				hasPrevious and self:GetPrevious().frame or self.renderFrame,
				hasPrevious and "BOTTOMLEFT" or "TOPLEFT",
				hasPrevious and 0 or 14,
				hasPrevious and 0 or -10)
	else
		frame:SetPoint(
				"BOTTOMLEFT",
				hasPrevious and self:GetPrevious().frame or self.renderFrame,
				hasPrevious and "BOTTOMLEFT" or "TOPLEFT",
				hasPrevious and 0 or 14,
				hasPrevious and 0 or -10)
	end
	frame:SetPoint("RIGHT", self.renderFrame, "RIGHT", 0, 0)
	frame:SetShown(shown)
end

function UpdateTaskContainer(self)
	local currentStep = Guide.GetCurrentStep()
	local taskGroup = currentStep[self.parent:GetIndex()]
	local taskIdx = self:GetIndex()
	local task = taskGroup[taskIdx]
	if (task and task.conditionPassed) then
		local taskType = GetTaskType(task)
		taskType:Render(task, self)
		self:SetShown(true)
		local height
		if (self.text:IsShown()) then
			height = self.text:GetStringHeight() + 7
			for _, taskDetailContainer in ipairs(self.taskDetailContainers) do
				if (taskDetailContainer.text:IsShown()) then
					height = height + taskDetailContainer.text:GetStringHeight()
				end
			end
		elseif (self.button:IsShown()) then
			height = 25
		else
			height = 0
		end
		if (taskType.compactable) then
			for i = taskIdx + 1, #taskGroup do
				local nextTask = taskGroup[i]
				if (nextTask and nextTask.conditionPassed) then
					local nextTaskType = GetTaskType(nextTask)
					if (nextTaskType.compactable) then
						height = height - 6
					end
					break
				end
			end
		end
		self.frame:SetHeight(height)
		self.frame:SetAlpha((taskType:IsDimmable(task)
				and (not UI.IsTaskGroupDimmed(task.parent)) and Guide.IsStepNodeCompleted(task)) and DIM or 1.0)
	else
		self:SetShown(false)
	end
end

function UpdateAllTaskContainers(self)
	local currentStep = Guide.GetCurrentStep()
	local taskGroup = currentStep[self.parent:GetIndex()]
	for idx = 1, math.max(#taskGroup, #self) do
		self[idx]:Update()
	end
end

function component.CreateFactory(parent, renderFrame)
	local factory = CreateFactory(function()
		return CreateTaskContainer(parent, renderFrame)
	end, {
		GetHeight = GetTaskContainersHeight,
		UpdateAll = UpdateAllTaskContainers,
		parent = parent,
		renderFrame = renderFrame
	})
	return factory
end

function component.Init(components)
	taskDetailContainers = components.TaskDetailContainers
end

UI.Add(component)
