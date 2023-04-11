--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

Waypoint = { }

local arrow = addon.CreateArrow(0,1, 0)
local lastWaypoint
local tooltipLabel = "Joana's Guide"
local waypointUpdateFrame = CreateFrame("Frame")
local lastStep

function Waypoint.Update()
	local currentStep = Guide.GetCurrentStep()
	if (currentStep ~= lastStep) then
		lastStep = currentStep
		if (currentStep and currentStep.waypoint) then
			local label = currentStep.waypoint[3]
			local npcID
			local npcName
			if (not label) then
				for _, v in ipairs(currentStep) do
					if (type(v) == "table" and v.npc) then
						npcID = v.npc
						npcName = GetCreatureName(npcID)
						break
					end
				end
			end
			local waypointLabel = label or npcName or (npcID and "...") or "Joana's Guide"
			SetWaypoint(currentStep.map, currentStep.waypoint[1] / 100, currentStep.waypoint[2] / 100, waypointLabel)
			if (npcID and not npcName) then
				waypointUpdateFrame:SetScript("OnUpdate", function()
					npcName = GetCreatureName(npcID)
					if (npcName) then
						SetWaypoint(currentStep.map, currentStep.waypoint[1] / 100, currentStep.waypoint[2] / 100, npcName)
						waypointUpdateFrame:SetScript("OnUpdate", nil)
					end
				end)
			end
		else
			ClearWaypoint()
		end
	end
end

function ClearWaypoint()
	arrow:ClearTarget()
	if (TomTom) then
		if (lastWaypoint) then
			TomTom:RemoveWaypoint(lastWaypoint)
			lastWaypoint = nil
		end
	end
end

function SetWaypoint(mapID, x, y, label)
	arrow:SetTarget(x, y, mapID)
	tooltipLabel = label or "Joana's Guide"
	if (TomTom) then
		if (lastWaypoint) then
			TomTom:RemoveWaypoint(lastWaypoint)
			lastWaypoint = nil
		end
		lastWaypoint = TomTom:AddWaypoint(mapID, x, y, {
			title = tooltipLabel,
			persistent = false,
			minimap = false,
			world = true,
			from = "Joana's Guide",
--			cleardistance = 5
		})
	end
end

arrow.tooltip = {
	Show = function(this)
		GameTooltip:ClearLines()
		GameTooltip:SetOwner(this, "ANCHOR_CURSOR")
		GameTooltip:SetText(tooltipLabel, 1, 1, 1)
		GameTooltip:Show()
	end,
	Hide = function()
		GameTooltip:Hide()
	end
}
