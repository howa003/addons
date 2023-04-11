--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("HeaderTitle")

function component.Init(components)
	local parent = components.Header.frame
	local text = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	text:SetPoint("BOTTOM", parent, "BOTTOM", 0, 14)
	component.text = text
end

function component.Update()
	if (component:IsDirty()) then
		component.text:SetText(Guide.GetCurrentStepTitle())
		component:MarkClean()
	end
end

UI.Add(component)
