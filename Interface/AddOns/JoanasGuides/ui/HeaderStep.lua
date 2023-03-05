--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("HeaderStep")

function component.Init(components)
	local parent = components.Header.frame
	local text = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	text:SetPoint("BOTTOM", parent, "TOP", 0, 0)
	text:Hide()
	component.text = text
end

function component.Update()
	if (component:IsDirty()) then
		local isShown = State.IsStepIDEnabled()
		if (isShown) then
			local currentStep = Guide.GetCurrentStep()
			if (currentStep) then
				component.text:SetText(("Step: %s"):format(currentStep.id))
			else
				isShown = false
			end
		end
		component.text:SetShown(isShown)
		component:MarkClean()
	end
end

function UI.SetStep(stepID)
	component.text:SetText(("Step: %s"):format(stepID))
end

UI.Add(component)
