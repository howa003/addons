--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("HeaderNextButton")

function component.Init(components)
	local parent = components.Header.frame
	local frame = CreateFrame("Button", nil, parent)
	frame:SetSize(24,24)
	frame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", - 4, 10)
	frame:Disable()
	AddNormalTexture(frame, I["UI-SquareButton-Down-Up"])
	AddDisabledTexture(frame, I["UI-SquareButton-Down-Disabled"])
	AddHighlightTexture(
			frame,
			CreateTexture("Interface\\Buttons\\UI-Common-MouseHilight",nil,nil, "ADD"))
	AddPushedTexture(frame, I["UI-SquareButton-Down-Down"])
	frame:SetScript("OnClick", function()
		if (IsShiftKeyDown()) then
			Guide.GotoNextStep(false)
		else
			Guide.GotoNextStep(true)
		end
	end)
	component.frame = frame
end

function component.Update()
	if (component:IsDirty()) then
		component.frame:SetEnabled(Guide.HasNextStep())
		component:MarkClean()
	end
end

UI.Add(component)
