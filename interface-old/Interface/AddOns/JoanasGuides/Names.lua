--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

Names = { }

local EventFrame = CreateFrame("Frame")

local interval, minInterval, maxInterval, timeSinceLastUpdate = 1, 1/15, 1, 0
local queue = { }

--todo: Purge queue whenever the guide step has changed
local function OnUpdate(_, elapsed)
	timeSinceLastUpdate = timeSinceLastUpdate + elapsed
	if (timeSinceLastUpdate > interval) then
		timeSinceLastUpdate = 0
		if (#queue == 0) then
			interval = maxInterval
			return
		end
		for _ = 1, #queue do
			local entry = table.remove(queue, 1)
			local value = entry[2](select(3, unpack(entry)))
			if (not value) then
				table.insert(queue, entry)
			else
				queue[entry[1]] = nil
				UI.MarkDirty()
			end
		end
	end
end

function Names.GetName(func, ...)
	local name = func(...)
	if (not name) then
		local call = { func, ... }
		local key = { }
		for idx, val in ipairs(call) do
			key[idx] = tostring(val)
		end
		key = table.concat(key)
		if (not queue[key]) then
			table.insert(queue, { key, func, ... })
			queue[key] = true
		end
		interval = minInterval
		return "..."
	end
	return name
end

EventFrame:SetScript("OnUpdate", OnUpdate)
