--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("ItemActionButtons")

local LEFT, RIGHT = 1, 2
local UNKNOWN_ITEM_TEXTURE = 134400

local buttonsInitialized = 0
local buttonSide = LEFT
local guideContainer
local header
local isCombatDirty
local itemActionButtons
local lastStep
local taskGroupContainers
local tooltipItemShown
local updateTimer = -1

local AttachItemTooltip, CalculateYOffset, CreateItemActionButton, FindContainerItem, OnDragStart, OnEnter, OnEvent,
	OnLeave, RefreshButtonCooldown

local ButtonWrapperMixin = { }

function ButtonWrapperMixin:IsShown()
	return self[1]:IsShown()
end

function ButtonWrapperMixin:SetItemID(itemID)
	self[1]:SetAttribute("item", ("item:%s"):format(itemID or 0))
	self[1].itemID = itemID
	self[2]:SetAttribute("item", ("item:%s"):format(itemID or 0))
	self[2].itemID = itemID
end

function ButtonWrapperMixin:SetUnavailable(unavailable)
	self[1].icon:SetDesaturated(unavailable)
	self[2].icon:SetDesaturated(unavailable)
	if (unavailable) then
		self[1].icon:SetVertexColor(0.4, 0.4, 0.4)
		self[2].icon:SetVertexColor(0.4, 0.4, 0.4)
	else
		self[1].icon:SetVertexColor(1, 1, 1)
		self[2].icon:SetVertexColor(1, 1, 1)
	end
end

function ButtonWrapperMixin:SetIconTexture(...)
	self[1].icon:SetTexture(...)
	self[2].icon:SetTexture(...)
end

function ButtonWrapperMixin:SetShown(shown)
	self.shown = shown
	if (not InCombatLockdown()) then
		self[1]:SetShown(shown)
		self[2]:SetShown(shown)
	end
	if (shown) then
		local yOffset = CalculateYOffset(header.frame:GetBottom(), self:GetIndex())
		if (math.abs(self.yOffset - yOffset) < 1) then
			self[buttonSide]:SetAlpha(1)
			self[buttonSide].cover:SetShown(false)
			self[buttonSide].cooldown:SetDrawBling(true)
		else
			self.shown = false
		end
	else
		self[buttonSide]:SetAlpha(0.001)
		self[buttonSide].cover:SetShown(true)
		self[buttonSide].cooldown:SetDrawBling(false)
	end
	taskGroupContainers.Get(self:GetIndex()).itemShown = self.shown
end

function ButtonWrapperMixin:SetYOffset(yOffset)
	self[1]:ClearAllPoints()
	self[1]:SetPoint("RIGHT", header.frame, "BOTTOMLEFT", -18, yOffset)
	self[2]:ClearAllPoints()
	self[2]:SetPoint("LEFT", header.frame, "BOTTOMRIGHT", 4, yOffset)
	self.yOffset = yOffset
end

function ButtonWrapperMixin:UpdateCount()
	local itemID = self[1].itemID
	if (itemID) then
		local _, _, _, _, _, _, _, stackCount = GetItemInfo(itemID)
		if (stackCount and stackCount > 1) then
			local itemCount = GetItemCount(itemID, true)
			self[1].Count:SetText(itemCount)
			self[2].Count:SetText(itemCount)
			self[1].Count:Show()
			self[2].Count:Show()
			return
		end
	end
	self[1].Count:Hide()
	self[2].Count:Hide()
end

function AttachItemTooltip(self)
	if (tooltipItemShown) then
		local availNow = GetItemCount(tooltipItemShown, false)
		local availTotal = GetItemCount(tooltipItemShown, true)
		if (availNow == 0) then
			self:AddLine(" ")
			if (availTotal ~= 0) then
				self:AddLine("|CFFFF0000Item is in your bank|r")
			else
				self:AddLine("|CFFFF0000You do not have this item|r")
			end
		end
		if (availNow > 0) then
			self:AddLine(" ")
			self:AddLine("|CFFFFFF00Shift-click to drag onto the action bar|r")
		end
		self:Show()
	end
end

function CalculateYOffset(fromY, buttonIdx)
	local taskGroupContainer = taskGroupContainers.Get(buttonIdx)
	local taskGroupContainerMiddle = taskGroupContainer.frame:GetBottom() + (taskGroupContainer.frame:GetHeight() / 2)
	local yOffset = taskGroupContainerMiddle - fromY + 2.5
	return yOffset
end

function CreateItemActionButton()
	local buttonWrapper = CreateFromMixins(ButtonWrapperMixin)
	for i = 1, 2 do
		local button = CreateFrame("Button", nil, guideContainer.frame, "SecureActionButtonTemplate")
		button.idx = i
		buttonWrapper[i] = button
		button:SetSize(26, 26)
		local buttonCover = CreateFrame("Button", nil, button)
		buttonCover:SetSize(26, 26)
		buttonCover:SetPoint("CENTER", button, "CENTER", 0, 0)
		buttonCover:SetFrameLevel(button:GetFrameLevel() + 1)
		buttonCover:Hide()
		button.cover = buttonCover
		button.icon = button:CreateTexture(nil, "BACKGROUND")
		button.icon:SetAllPoints()
		button.hotkey = button:CreateFontString(nil, "ARTWORK", "NumberFontNormalSmallGray")
		button.hotkey:SetText(RANGE_INDICATOR)
		button.hotkey:SetJustifyH("LEFT")
		button.hotkey:SetSize(29, 10)
		button.hotkey:SetPoint("TOPRIGHT", 16, -2)
		button.hotkey:Hide()
		button.Count = button:CreateFontString(nil, "ARTWORK", "NumberFontNormal")
		button.Count:SetJustifyH("RIGHT")
		button.Count:SetPoint("BOTTOMRIGHT", -3, 2)
		button.Count:SetScale(0.7)
		button.Count:Hide()
		button.IconBorder = AddTexture(
				button,
				{ texture = "Interface/Common/WhiteIconFrame", level = "OVERLAY" },
				26,
				26,
				"CENTER"
		)
		button.IconBorder:Hide()
		button.IconOverlay = AddTexture(
				button,
				{ texture = "Interface/Common/WhiteIconFrame", level = "OVERLAY", drawLayer = 1 },
				26,
				26,
				"CENTER"
		)
		button.IconOverlay:Hide()
		button.cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
		button.cooldown:SetScale(0.7)
		AddNormalTexture(button,"Interface/Buttons/UI-Quickslot2", 42, 42,"CENTER")
		AddPushedTexture(button, "Interface/Buttons/UI-Quickslot-Depress")
		AddHighlightTexture(button, "Interface/Buttons/ButtonHilight-Square")
		button:SetAttribute("type1", "item")
		button:RegisterForDrag("LeftButton");
		button:SetScript("OnEnter", OnEnter)
		button:SetScript("OnLeave", OnLeave)
		button:SetScript("OnDragStart", OnDragStart)
		button:SetScript("OnEvent", OnEvent)
		button:RegisterEvent("BAG_UPDATE_COOLDOWN")
		button:Show()
	end
	return buttonWrapper
end

function FindContainerItem(itemID)
	if (itemID) then
		for bagID = 0, 4 do
			for slot = 1, GetContainerNumSlots(bagID) do
				local itemLink = GetContainerItemLink(bagID, slot)
				if (itemLink) then
					local itemID_ = GetItemInfoInstant(itemLink)
					if (itemID_ == itemID) then
						return bagID, slot
					end
				end
			end
		end
	end
end

function OnDragStart(self)
	if (IsShiftKeyDown()) then
		local bagID, slot = FindContainerItem(self.itemID)
		if (bagID) then
			PickupContainerItem(bagID, slot)
		end
	end
end

function OnEnter(self)
	tooltipItemShown = self.itemID
	if (GetCVar("UberTooltips") == "1") then
		GameTooltip_SetDefaultAnchor(GameTooltip, self);
	else
		GameTooltip:SetOwner(self, self.idx == 1 and "ANCHOR_LEFT" or "ANCHOR_RIGHT");
	end
	GameTooltip:SetItemByID(self.itemID);
end

function OnEvent(self, event)
	if (event == "BAG_UPDATE_COOLDOWN") then
		RefreshButtonCooldown(self)
	end
end

function OnLeave()
	if (tooltipItemShown) then
		tooltipItemShown = nil
		GameTooltip:Hide()
	end
end

function RefreshButtonCooldown(self)
	local bagID, slot = FindContainerItem(self.itemID)
	if (bagID) then
		local start, duration, enable = GetContainerItemCooldown(bagID, slot);
		CooldownFrame_Set(self.cooldown, start, duration, enable);
	else
		CooldownFrame_Set(self.cooldown, 0, 0, false);
	end
end

function component.Init(components)
	guideContainer = components.GuideContainer
	header = components.Header
	taskGroupContainers = components.TaskGroupContainers
	itemActionButtons = CreateFactory(CreateItemActionButton)
	GameTooltip:HookScript("OnTooltipSetItem", AttachItemTooltip)
end

function component.Update()
	isCombatDirty = isCombatDirty or UI.IsDirty()
	if (component:IsDirty()) then
		local currentStep = Guide.GetCurrentStep()
		if (InCombatLockdown()) then
			if (lastStep ~= currentStep) then lastStep = nil end
			if (isCombatDirty) then
				isCombatDirty = false
				for idx, buttonWrapper in ipairs(itemActionButtons) do
					local taskGroup = currentStep and currentStep[idx]
					local shown = taskGroup and taskGroup.conditionPassed and taskGroup.item ~= nil and not UI.IsTaskGroupDimmed(taskGroup) and lastStep ~= nil
					buttonWrapper:SetShown(shown)
				end
			end
		else
			component:MarkClean()
			isCombatDirty = false
			local headerBottom = header.frame:GetBottom()
			for idx = 1, math.max(currentStep and #currentStep or 0, #itemActionButtons) do
				local itemActionButton = itemActionButtons[idx]
				local taskGroup = currentStep and currentStep[idx]
				itemActionButton:SetYOffset(CalculateYOffset(headerBottom, idx))
				local shown = taskGroup and taskGroup.conditionPassed and taskGroup.item ~= nil and not UI.IsTaskGroupDimmed(taskGroup)
				itemActionButton:SetShown(shown)
				if (shown) then
					local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(taskGroup.item)
					itemActionButton:SetItemID(taskGroup.item)
					itemActionButton:SetIconTexture(texture or UNKNOWN_ITEM_TEXTURE)
					RefreshButtonCooldown(itemActionButton[1])
					RefreshButtonCooldown(itemActionButton[2])
					local itemCount = taskGroup.item and GetItemCount(taskGroup.item, false) or 0
					itemActionButton:SetUnavailable(itemCount == 0)
					itemActionButton:UpdateCount()
				else
					itemActionButton:SetItemID(nil)
				end
			end
			lastStep = currentStep
		end
	end
	if (UI.IsGuideContainerMoving() or buttonsInitialized < #itemActionButtons) then
		buttonsInitialized = #itemActionButtons
		local l1, _, w1 = guideContainer.frame:GetScaledRect()
		local l2, _, w2 = UIParent:GetScaledRect()
		local left = l1 - l2
		local right = w2 - (l1 + w1)
		buttonSide = left > right and LEFT or RIGHT
		for _, buttonWrappers in ipairs(itemActionButtons) do
			for idx, buttonWrapper in ipairs(buttonWrappers) do
				if (idx == buttonSide and buttonWrappers.shown) then
					buttonWrapper:SetAlpha(1.0)
					buttonWrapper.cover:SetShown(false)
					buttonWrapper.cooldown:SetDrawBling(true)
				else
					buttonWrapper:SetAlpha(0.001)
					buttonWrapper.cover:SetShown(true)
					buttonWrapper.cooldown:SetDrawBling(false)
				end
			end
		end
	end
	updateTimer = updateTimer - UI.GetElapsed()
	if ( updateTimer <= 0 ) then
		for _, itemActionButton in ipairs(itemActionButtons) do
			local hotkeyShown = false
			if (itemActionButton[1].itemID) then
				local valid
				local questLogIdx = GetQuestLogIndexForItem(itemActionButton[1].itemID)
				if (questLogIdx) then
					valid = IsQuestLogSpecialItemInRange(questLogIdx);
				end
				if ( valid == 0 ) then
					hotkeyShown = true
					itemActionButton[1].hotkey:SetVertexColor(1.0, 0.1, 0.1);
					itemActionButton[2].hotkey:SetVertexColor(1.0, 0.1, 0.1);
				elseif ( valid == 1 ) then
					hotkeyShown = true
					itemActionButton[1].hotkey:SetVertexColor(0.6, 0.6, 0.6);
					itemActionButton[2].hotkey:SetVertexColor(0.6, 0.6, 0.6);
				end
			end
			itemActionButton[1].hotkey:SetShown(hotkeyShown)
			itemActionButton[2].hotkey:SetShown(hotkeyShown)
			if (itemActionButton[1].itemID and itemActionButton[1].icon:GetTexture() == UNKNOWN_ITEM_TEXTURE) then
				local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemActionButton[1].itemID)
				if (texture) then
					itemActionButton[1].icon:SetTexture(texture)
					itemActionButton[2].icon:SetTexture(texture)
					itemActionButton:UpdateCount()
				end
			end
		end
		updateTimer = TOOLTIP_UPDATE_TIME;
	end
end

UI.Add(component)