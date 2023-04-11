--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

Debug = { }

local DEBUG_MSG = "WoW Build: %s %s\n"..
		"Addon Version: %s\n"..
		"Guide ID: %s\n"..
		"Guide Version: %s\n"..
		"Step: %s"

function Debug.AnnounceStep()
	if (State.IsDebugEnabled()) then
		DEFAULT_CHAT_FRAME:AddMessage("Current Step: " .. Guide.GetCurrentStep().id)
	end
end

function Debug.GetDebugInfo()
	local wowVersion, wowBuild = GetBuildInfo()
	local guideID = "None"
	local guideVersion = "None"
	if (Guide.GetCurrentGuide()) then
		guideID = Guide.GetCurrentGuide().id
		guideVersion = Guide.GetCurrentGuide().moduleInfo.version
	end
	local stepID = Guide.GetCurrentStep() and Guide.GetCurrentStep().id or "None"
	return DEBUG_MSG:format(wowVersion, wowBuild, GuideModules.GetAddonVersion(), guideID, guideVersion, stepID)
end
