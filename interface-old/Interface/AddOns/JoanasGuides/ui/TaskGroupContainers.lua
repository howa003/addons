--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("TaskGroupContainers")

local guideFrame
local isCombatDirty
local lastStep
local taskContainers
local taskGroupContainers

local CreateTaskGroupContainer, ResetTaskGroupContainer, SwapBuffer, TaskGroupContainerMarkCombatDirty,
	TaskGroupContainerSetShown, TryTransition

function CreateTaskGroupContainer()
	local taskGroupContainer = { }
	local frame = CreateFrame("Frame", nil, guideFrame, "BackdropTemplate")
	frame.boundingBox = CreateFrame("Frame", nil, guideFrame)
	frame.boundingBox:SetSize(240, 50)
	frame.boundingBox:Show()
	frame:SetSize(240, 50)
	frame.backdropInfo = BACKDROP_GLUE_TOOLTIP_16_16
	frame.backdropColor = GLUE_BACKDROP_COLOR
	frame.backdropColorAlpha = 1.0
	frame.backdropBorderColor = GLUE_BACKDROP_BORDER_COLOR
	frame:OnBackdropLoaded()
	taskGroupContainer.contents = CreateFrame("Frame", nil, frame)
	taskGroupContainer.contents:SetAllPoints()
	taskGroupContainer.contents.taskContainers = taskContainers.CreateFactory(taskGroupContainer, taskGroupContainer.contents)
	taskGroupContainer.buffer = CreateFrame("Frame", nil, frame)
	taskGroupContainer.buffer:SetAllPoints()
	taskGroupContainer.buffer:Hide()
	taskGroupContainer.buffer.taskContainers = taskContainers.CreateFactory(taskGroupContainer, taskGroupContainer.buffer)
	taskGroupContainer.SetShown = TaskGroupContainerSetShown
	taskGroupContainer.MarkCombatDirty = TaskGroupContainerMarkCombatDirty
	taskGroupContainer.frame = frame
	taskGroupContainer.hideAnim = taskGroupContainer.frame:CreateAnimationGroup()
	taskGroupContainer.hideAnim.alpha = taskGroupContainer.hideAnim:CreateAnimation("Alpha")
	taskGroupContainer.hideAnim.alpha:SetDuration(1)
	taskGroupContainer.hideAnim.alpha:SetStartDelay(3)
	taskGroupContainer.hideAnim.alpha:SetFromAlpha(DIM)
	taskGroupContainer.hideAnim.alpha:SetToAlpha(0)
	taskGroupContainer.hideAnim.alpha:SetOrder(1)
	taskGroupContainer.hideAnim.alpha:SetTarget(taskGroupContainer.frame)
	taskGroupContainer.hideAnim:SetLooping("NONE")
	taskGroupContainer.hideAnim:SetToFinalAlpha(true)
	taskGroupContainer.hideAnim:SetScript("OnFinished", function()
		taskGroupContainer.hideDone = true
		UI:MarkDirty()
	end)
	return taskGroupContainer
end

function ResetTaskGroupContainer(taskGroupContainer)
	taskGroupContainer.resizing = nil
	taskGroupContainer.hiding = nil
	taskGroupContainer.isCombatDirty = nil
	taskGroupContainer.fading = nil
end

function SwapBuffer(taskGroupContainer)
	local newContents = taskGroupContainer.buffer
	taskGroupContainer.buffer = taskGroupContainer.contents
	taskGroupContainer.buffer:SetShown(false)
	taskGroupContainer.contents = newContents
	taskGroupContainer.contents:SetShown(true)
end

function TaskGroupContainerMarkCombatDirty(self)
	self.isCombatDirty = true
	isCombatDirty = true
end

function TaskGroupContainerSetShown(self, shown)
	local frame = self.frame
	frame:ClearAllPoints()
	local hasPrevious = self:HasPrevious()
	frame:SetPoint(
			shown and "TOPLEFT" or "BOTTOMLEFT",
			hasPrevious and self:GetPrevious().frame or guideFrame.Header,
			"BOTTOMLEFT",
			hasPrevious and 0 or -20,
			shown and 2 or 0)
	frame:SetShown(shown)
end


function TryTransition()
	isCombatDirty = nil
	local currentStep = Guide.GetCurrentStep()
	local inCombatLockdown = InCombatLockdown()
	local isSafe = true
	for i = #taskGroupContainers, 1, -1 do
		local taskGroupContainer = taskGroupContainers[i]
		local hasItem = currentStep and currentStep[i] and currentStep[i].item and taskGroupContainer.itemShown
		isSafe = isSafe and ((not inCombatLockdown) or taskGroupContainer.dimmed or
				(not taskGroupContainer.frame:IsShown())
				or (not hasItem)
				or taskGroupContainer.hiding or taskGroupContainer.fading)
		if (taskGroupContainer.isCombatDirty) then
			if (isSafe) then
				taskGroupContainer.isCombatDirty = nil
				if (taskGroupContainer.resizing) then
					SwapBuffer(taskGroupContainer)
					taskGroupContainer.frame:SetHeight(taskGroupContainer.contents.taskContainers:GetHeight())
					taskGroupContainer.resizing = nil
				end
				if (taskGroupContainer.hiding) then
					taskGroupContainer:SetShown(false)
					taskGroupContainer.hiding = nil
				end
				if (taskGroupContainer.showing) then
					taskGroupContainer:SetShown(true)
					taskGroupContainer.showing = nil
				end
				if (taskGroupContainer.fading) then
					if (taskGroupContainer.hideDone) then
						taskGroupContainer:SetShown(false)
						taskGroupContainer.hideDone = nil
					elseif (not taskGroupContainer.dimmed and not taskGroupContainer.hideAnim:IsPlaying()) then
						taskGroupContainer.hideAnim:Play()
					end
					taskGroupContainer.fading = nil
				end
			else
				if (taskGroupContainer.fading) then
					taskGroupContainer.hideAnim:Stop()
					taskGroupContainer.frame:SetAlpha(DIM)
				end
				isCombatDirty = true
				break;
			end
		end
	end
end

function component.Init(components)
	guideFrame = components.GuideContainer.frame
	taskContainers = components.TaskContainers
	taskGroupContainers = CreateFactory(CreateTaskGroupContainer)
end

function component.Update()
	local currentStep = Guide.GetCurrentStep()
	local inCombatLockdown = InCombatLockdown()
	if (component:IsDirty()) then
		if (currentStep) then
			for idx, taskGroup in ipairs(currentStep) do
				local taskGroupContainer = taskGroupContainers[idx]
				ResetTaskGroupContainer(taskGroupContainer)
				local taskGroupContainerFrame = taskGroupContainer.frame
				if (currentStep ~= lastStep) then
					taskGroupContainer.hideAnim:Stop()
					taskGroupContainer.dimmed = nil
					taskGroupContainer.hideDone = nil
					if (not taskGroup.conditionPassed) then
						taskGroupContainer:SetShown(false)
					elseif (UI.IsTaskGroupDimmed(taskGroup) == true) then
						if (Guide.IsAutoAdvanceStep()) then
							taskGroupContainer:SetShown(false)
						else
							taskGroupContainerFrame:SetAlpha(DIM)
							taskGroupContainer:SetShown(true)
							taskGroupContainer.dimmed = true
						end
					else
						taskGroupContainerFrame:SetAlpha(1.0)
						taskGroupContainer:SetShown(true)
					end
				else
					if (not taskGroup.conditionPassed) then
						if (taskGroupContainerFrame:IsShown()) then
							if (inCombatLockdown) then
								taskGroupContainer:MarkCombatDirty()
								taskGroupContainer.hiding = true
							else
								taskGroupContainer:SetShown(false)
							end
						end
					elseif (UI.IsTaskGroupDimmed(taskGroup) == true) then
						if (taskGroupContainerFrame:IsShown()) then
							if (taskGroupContainer.hideDone) then
								if (inCombatLockdown) then
									taskGroupContainer:MarkCombatDirty()
									taskGroupContainer.fading = true
								else
									taskGroupContainer:SetShown(false)
									taskGroupContainer.hideDone = nil
								end
							elseif (not taskGroupContainer.dimmed and not taskGroupContainer.hideAnim:IsPlaying()) then
								taskGroupContainerFrame:SetAlpha(DIM)
								taskGroupContainer:MarkCombatDirty()
								taskGroupContainer.fading = true
							end
						end
					else
						taskGroupContainer.hideAnim:Stop()
						taskGroupContainerFrame:SetAlpha(1.0)
						if (not taskGroupContainerFrame:IsShown()) then
							if (inCombatLockdown) then
								taskGroupContainer:MarkCombatDirty()
								taskGroupContainer.showing = true
							else
								taskGroupContainer:SetShown(true)
							end
						end
						taskGroupContainer.dimmed = nil
					end
				end
				if (taskGroupContainerFrame:IsShown() or taskGroupContainer.showing) then
					taskGroupContainer.buffer.taskContainers:UpdateAll()
					local newHeight = taskGroupContainer.buffer.taskContainers:GetHeight()
					local currentHeight = taskGroupContainerFrame:GetHeight()
					if (lastStep ~= currentStep or not inCombatLockdown) then
						SwapBuffer(taskGroupContainer)
						taskGroupContainerFrame:SetHeight(newHeight)
					elseif (math.abs(newHeight - currentHeight) < 1) then
						SwapBuffer(taskGroupContainer)
					else
						taskGroupContainer:MarkCombatDirty()
						taskGroupContainer.resizing = true
					end
				end
			end
			for i = #currentStep + 1, #taskGroupContainers do
				ResetTaskGroupContainer(taskGroupContainers[i])
				taskGroupContainers[i]:SetShown(false)
			end
		else
			for _, taskGroupContainer in ipairs(taskGroupContainers) do
				ResetTaskGroupContainer(taskGroupContainer)
				taskGroupContainer:SetShown(false)
			end
		end
		lastStep = currentStep
		if (isCombatDirty) then
			TryTransition()
		end
		component:MarkClean()
		return
	end
	if (isCombatDirty and not inCombatLockdown) then
		TryTransition()
	end
end

function component.Get(idx)
	return taskGroupContainers[idx]
end

function component.IsShown()
	for _, v in ipairs(taskGroupContainers) do
		if (v.frame:IsShown()) then
			return true
		end
	end
	return false
end

UI.Add(component)
