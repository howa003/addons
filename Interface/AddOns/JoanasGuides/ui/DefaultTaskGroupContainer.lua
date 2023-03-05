--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("DefaultTaskGroupContainer")

local OOPS_MSG = "Oops! It seems that something should be displayed here.\n\n" ..
	"Please report the issue to Joana's Guides Support and be sure to provide the following info:\n\n%s"

local guideFrame
local headerFrame
local TaskGroupContainers
local defaultTaskGroupContainer

function component.Init(components)
	guideFrame = components.GuideContainer.frame
	headerFrame = components.Header.frame
	TaskGroupContainers = components.TaskGroupContainers
	defaultTaskGroupContainer = { }

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
	defaultTaskGroupContainer.frame = frame
	frame:SetPoint("TOPLEFT", headerFrame, "BOTTOMLEFT", -20, 2)
	frame:SetShown(false)

	local text = frame:CreateFontString(nil, "ARTWORK", "GameFontWhiteSmall")
	text:SetJustifyH("LEFT")
	text:SetPoint("TOPLEFT", frame, "TOPLEFT", 14, -10)
	text:SetPoint("RIGHT", frame, "RIGHT", -10, 0)
	text:SetText("This is a test This is a test")

	defaultTaskGroupContainer.text = text

end

function component.Update()
	if (component:IsDirty()) then
		local currentStep = Guide.GetCurrentStep()
		if ((not currentStep) or TaskGroupContainers.IsShown()) then
			defaultTaskGroupContainer.frame:SetShown(false)
		else
			defaultTaskGroupContainer.frame:SetShown(true)
			if (currentStep.within) then
				defaultTaskGroupContainer.text:SetText(
						("Go to %d,%d in %s"):format(
								currentStep.waypoint[1],
								currentStep.waypoint[2],
								Names.GetName(GetMapName, currentStep.map)))
			else
				defaultTaskGroupContainer.text:SetText(OOPS_MSG:format(Debug.GetDebugInfo()))
			end
			defaultTaskGroupContainer.frame:SetHeight(defaultTaskGroupContainer.text:GetStringHeight() + 26)
		end
		component:MarkClean()
	end
end

UI.Add(component)
