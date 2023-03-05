--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("HeaderSettingsButton")

function component.Init(components)
	local parent = components.Header.frame
	local frame = CreateFrame("Button", nil, parent)
	frame:SetSize(30, 30)
	frame:SetPoint("BOTTOMRIGHT", parent.IconBorder, "BOTTOMRIGHT", 2, -2)
	AddTexture(
			frame,
			"Interface\\Minimap\\MiniMap-TrackingBorder",
			52, 52,
			"TOPLEFT")
	AddTexture(
			frame,
			CreateTexture(
					"Interface\\Minimap\\UI-Minimap-Background",
					"BACKGROUND"
			),
			24,24,
			{ "TOPLEFT", 2, -2 })
	AddNormalTexture(
			frame,
			"Interface\\Worldmap\\Gear_64Grey",
			18, 18,
			{ "TOPLEFT", 6.5, -5.5 })
	AddHighlightTexture(
			frame,
			"Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	AddPushedTexture(
			frame,
			"Interface\\Worldmap\\Gear_64Grey",
			18, 18,
			{ "TOPLEFT", 7.5, -6.5 })
	frame:SetScript("OnClick", function()
		UI.ToggleGuideMenu()
	end)
	component.frame = frame
end

UI.Add(component)
