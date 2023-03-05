--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local eventFrame = CreateFrame("Frame")
local questLogUpdated = false
local addonLoaded = false

local function OnEvent(self, event, arg1)
	if (event == "ADDON_LOADED" and addonName == arg1) then
		self:UnregisterEvent("ADDON_LOADED")
		State.Init()
		UI.Init()
		GuideModules.Reload()
		Condition_OnAddonLoad()
		addonLoaded = true
		Taxi_OnAddonLoaded()
	end
	if (event == "QUEST_LOG_UPDATE") then
		eventFrame:UnregisterEvent("QUEST_LOG_UPDATE")
		questLogUpdated = true
	end
	if (addonLoaded and questLogUpdated) then
		local lastGuide = State.GetGuide()
		if (lastGuide) then
			Guide.SetGuide(lastGuide)
		end
	end
end

eventFrame:SetScript("OnEvent", OnEvent)
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
