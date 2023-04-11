--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("HeaderLocation")

function component.Init(components)
	local parent = components.Header.frame
	local text = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetPoint("CENTER", parent, "CENTER", 10, 0)
	component.text = text
end

function component.Update()
	if (component:IsDirty()) then
		local text = component.text
		text:ClearAllPoints()
		text:SetScale(1.0)
		component.text:SetText(Guide.GetCurrentStepLocation())
		local textWidth = text:GetStringWidth()
		local newScale
		if (textWidth > 160) then
			newScale = 160 / textWidth
		else
			newScale = 1.0
		end
		text:SetScale(newScale)
		text:SetPoint("TOP", text:GetParent(), "TOP", 0, - 10 / newScale)
		component:MarkClean()
	end
end

UI.Add(component)
