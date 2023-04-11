--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

function IsPlayerWithin(taskGroup)
	local x, y = UnitPosition("player")
	if (x) then
		local step = Guide.GetCurrentStep()
		if (step.waypoint and not step.worldPosition) then
			local _, coordinate = C_Map.GetWorldPosFromMapPos(step.map, { x = step.waypoint[1] / 100, y = step.waypoint[2] / 100 })
			step.worldPosition = coordinate
		end
		local distance = addon.GetDistanceInYards(x, y, step.worldPosition.x, step.worldPosition.y)
		return distance <= taskGroup.within
	end
	return false
end
