--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local LibDropDownMenu = LibStub("LibDropDownMenu");

local component = UI.CreateComponent("GuideMenu")

local dropDownMenu
local menuData
local scaleSlider

local function createGuideMenu()
	local playerFaction = UnitFactionGroup("player")
	menuData = { }
	local filteredGuides = { }
	for _, guideInfo in ipairs(GuideInfos) do
		local moduleInfo = GuideModules.GetModule(guideInfo.moduleID)
		if (guideInfo.faction == playerFaction and moduleInfo and moduleInfo.installed and moduleInfo.compatible) then
			table.insert(filteredGuides, guideInfo)
		end
	end
	table.insert(
			menuData,
			{
				text = L["Guides"],
				isTitle = true,
				notCheckable = true
			})
	local submenus = { }
	for _, guideInfo in ipairs(filteredGuides) do
		local _menu = menuData
		if (guideInfo.group) then
			local submenu = submenus[guideInfo.group]
			if (not submenu) then
				submenu = { }
				table.insert(
						submenu,
						{
							text = guideInfo.group,
							isTitle = true,
							notCheckable = true
						})
				submenus[guideInfo.group] = submenu
				table.insert(menuData, {
					text = guideInfo.group,
					hasArrow = true,
					menuList = submenu,
					notCheckable = true
				})
			end
			_menu = submenu
		end
		table.insert(
				_menu,
				{
					text = guideInfo.description,
					value = guideInfo.guideID,
					isNotRadio = true,
					notCheckable = false,
					checked = function()
						local currentGuide = Guide.GetCurrentGuide()
						return (currentGuide and guideInfo.guideID == currentGuide.id) or false
					end,
					func = function()
						local currentGuide = Guide.GetCurrentGuide()
						if (currentGuide and guideInfo.guideID == currentGuide.id) then
							Guide.SetGuide()
						else
							Guide.SetGuide(guideInfo.guideID)
						end
						LibDropDownMenu.CloseDropDownMenus()
					end
				})
	end
	table.insert(
			menuData,
			{
				text = "",
				isTitle = true,
				notCheckable = true
			})
	table.insert(
			menuData,
			{
				text = L["Options"],
				isTitle = true,
				notCheckable = true
			})
	table.insert(
			menuData,
			{
				text = L["Hide Guide"],
				isNotRadio = true,
				notCheckable = false,
				checked = function()
					return false
				end,
				func = function()
					State.SetGuideShown(false)
				end
			})
	table.insert(
			menuData,
			{
				text = L["Automatic Quest Accept and Turn-In"],
				isNotRadio = true,
				notCheckable = false,
				checked = function()
					return IsAutoQuestsEnabled()
				end,
				func = function()
					SetAutoQuestsEnabled(not IsAutoQuestsEnabled())
				end
			})
	table.insert(
			menuData,
			{
				text = L["Sound on Objective Completion"],
				isNotRadio = true,
				notCheckable = false,
				checked = function()
					return IsObjectiveCompletionSoundEnabled()
				end,
				func = function()
					SetObjectiveCompletionSoundEnabled(not IsObjectiveCompletionSoundEnabled())
				end
			})
	table.insert(
			menuData,
			{
				text = L["Show Step ID"],
				isNotRadio = true,
				notCheckable = false,
				checked = function()
					return State.IsStepIDEnabled()
				end,
				func = function()
					State.SetStepIDEnabled(not State.IsStepIDEnabled())
				end
			})
	table.insert(
			menuData,
			{
				text = L["Lock Window"],
				isNotRadio = true,
				notCheckable = false,
				checked = function()
					return UI.IsGuideContainerLocked()
				end,
				func = function()
					UI.SetGuideContainerLocked(not UI.IsGuideContainerLocked())
				end
			})
	table.insert(
			menuData,
			{
				isNotRadio = true,
				notCheckable = false,
				leftPadding = scaleSlider.Text:GetStringWidth() + 30,
				text = "",
				customFrame = scaleSlider,
				keepShownOnClick = true
			}
	)
	return menuData
end

function component.Init()
	LibDropDownMenu = LibStub("LibDropDownMenu");
	dropDownMenu = LibDropDownMenu.Create_DropDownMenu(addonName .. "_DropDownMenu", UIParent);
	scaleSlider = CreateFrame("Slider", nil, nil, "OptionsSliderTemplate")
	--todo: Investigate how this is supposed to be implemented - UIDropDownCustomMenuEntryMixin is not the same as what comes from the lib
	Mixin(scaleSlider, UIDropDownCustomMenuEntryMixin)
	function scaleSlider:GetPreferredEntryHeight()
		return self:GetHeight();
	end
	scaleSlider:SetScript("OnEnter", scaleSlider.OnEnter)
	scaleSlider:SetScript("OnLeave", scaleSlider.OnLeave)
	scaleSlider:SetMinMaxValues(0.75, 1.75)
	scaleSlider:SetValueStep(0.05)
	scaleSlider:SetObeyStepOnDrag(true)
	scaleSlider.Low:SetText("-")
	scaleSlider.High:SetText("+")
	scaleSlider.Text:ClearAllPoints()
	scaleSlider.Text:SetPoint("RIGHT", scaleSlider, "LEFT", -10, 0)
	scaleSlider.Text:SetFontObject(GameFontHighlightSmallLeft)
	scaleSlider.Text:SetText("Scale")
	scaleSlider.SetDisplayValue = scaleSlider.SetValue;
	scaleSlider.GetValue = function()
		return State.GetGuideScale()
	end
	scaleSlider.GetCurrentValue = scaleSlider.GetValue
	scaleSlider.SetValue = function (self, value)
		if (not InCombatLockdown()) then
			self:SetDisplayValue(value);
			self.value = value;
			State.SetGuideScale(value)
		else
			self:SetDisplayValue(self.value);
		end
	end
	scaleSlider:SetScript("OnValueChanged", function(self, value)
		self:SetValue(value)
	end)
	scaleSlider:SetDisplayValue(State.GetGuideScale())
end

function UI.CloseGuideMenu()
	if (dropDownMenu == LibDropDownMenu.UIDROPDOWNMENU_OPEN_MENU) then
		LibDropDownMenu.CloseDropDownMenus()
	end
end

function UI.ToggleGuideMenu()
	if (dropDownMenu == LibDropDownMenu.UIDROPDOWNMENU_OPEN_MENU) then
		LibDropDownMenu.CloseDropDownMenus()
	else
		if (not menuData) then createGuideMenu() end
		local guideFrame = GetGuideFrame()
		local xoffset = 140 + guideFrame:GetRight() - UIParent:GetWidth() * UIParent:GetScale()
		LibDropDownMenu.EasyMenu(menuData, dropDownMenu, "cursor", xoffset < 0 and -10 or -xoffset, -10, "MENU")
	end
end

UI.Add(component)
