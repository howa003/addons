--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("TaskDetailContainers")

local CreateTaskDetailContainer, SetTaskDetailContainerAlpha, SetTaskDetailContainerShown, UpdateTaskDetailContainer, UpdateAllTaskDetailContainers

function CreateTaskDetailContainer(parent)
	local taskDetailContainer = { }
	taskDetailContainer.parent = parent
	taskDetailContainer.text = parent.frame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	taskDetailContainer.text:SetJustifyH("LEFT")
	taskDetailContainer.text:SetIndentedWordWrap(true)
	taskDetailContainer.icon = CreateFrame("Frame", nil, parent.frame)
	taskDetailContainer.icon:SetSize(1, ICON_SIZE)
	taskDetailContainer.icon:Hide()
	taskDetailContainer.icon.texture = taskDetailContainer.icon:CreateTexture()
	taskDetailContainer.icon.texture:SetPoint("CENTER")
	taskDetailContainer.SetShown = SetTaskDetailContainerShown
	taskDetailContainer.Update = UpdateTaskDetailContainer
	taskDetailContainer.SetAlpha = SetTaskDetailContainerAlpha
	return taskDetailContainer
end

function SetTaskDetailContainerAlpha(self, alpha)
	self.text:SetAlpha(alpha)
	self.icon:SetAlpha(alpha)
end

function SetTaskDetailContainerShown(self, shown)
	self.text:SetShown(shown)
	self.icon:SetShown(shown)
	local hasPrevious = self:HasPrevious()
	if (hasPrevious) then
		self.icon:SetPoint("TOPLEFT", self:GetPrevious().text, "BOTTOMLEFT", - (ICON_SIZE - 1), 0)
	else
		self.icon:SetPoint("TOPLEFT", self.parent.text, "BOTTOMLEFT", -4, 0)
	end
	self.text:SetPoint("TOPLEFT", self.icon, "TOPRIGHT", -3, 0)
	self.text:SetPoint("RIGHT", self.parent.frame, "RIGHT", -10, 0)
end

function UpdateTaskDetailContainer(self)

end

function UpdateAllTaskDetailContainers(self)

end

function component.CreateFactory(parent)
	local factory = CreateFactory(function()
		return CreateTaskDetailContainer(parent)
	end, {
		UpdateAll = UpdateAllTaskDetailContainers,
		parent = parent
	})
	return factory
end

UI.Add(component)
