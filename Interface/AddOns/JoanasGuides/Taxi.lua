--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local frame = CreateFrame("Frame")
local taxiMaps = {
	1463,   -- Eastern Kingdoms
	1464,   -- Kalimdor
	987,    -- Outland
	988,    -- Northrend
}
local Taxis
local TaxiNames

local function OnEvent()
	for _, map in ipairs(taxiMaps) do
		local taxiNodes = C_TaxiMap.GetAllTaxiNodes(map)
		for _, node in ipairs(taxiNodes) do
			if (node.state ~= Enum.FlightPathState.Unreachable) then
				Taxis[node.nodeID] = true
			end
		end
	end
	UI.MarkDirty()
end

frame:SetScript("OnEvent", OnEvent)
frame:RegisterEvent("TAXIMAP_OPENED")

function Taxi_OnAddonLoaded()
	SavedVariablesPerCharacter.knownTaxis = SavedVariablesPerCharacter.knownTaxis or { }
	Taxis = SavedVariablesPerCharacter.knownTaxis
	TaxiNames = { }
	for _, map in ipairs(taxiMaps) do
		local taxiNodes = C_TaxiMap.GetTaxiNodesForMap(map)
		for _, node in ipairs(taxiNodes) do
			TaxiNames[node.nodeID] = node.name
		end
	end
end

function HasTaxi(nodeID)
	return Taxis[nodeID] or false
end

function GetTaxiName(nodeID)
	return TaxiNames[nodeID] or "..."
end
