--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("HeaderBackButton")

function component.Init(components)
	local parent = components.Header.frame
	local frame = CreateFrame("Button", nil, parent)
	frame:SetSize(24,24)
	frame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", - 4, - 5)
	frame:Disable()
	AddNormalTexture(frame, I["UI-SquareButton-Up-Up"])
	AddDisabledTexture(frame, I["UI-SquareButton-Up-Disabled"])
	AddHighlightTexture(
			frame,
			CreateTexture("Interface\\Buttons\\UI-Common-MouseHilight",nil,nil, "ADD"))
	AddPushedTexture(frame, I["UI-SquareButton-Up-Down"])
	frame:SetScript("OnClick", function()
		if (IsShiftKeyDown()) then
			Guide.GotoPreviousStep(true)
		else
			Guide.GotoPreviousStep(false)
		end
	end)
	component.frame = frame
end

function component.Update()
	if (component:IsDirty()) then
		component.frame:SetEnabled(Guide.HasPreviousStep())
		component:MarkClean()
	end
end

UI.Add(component)
