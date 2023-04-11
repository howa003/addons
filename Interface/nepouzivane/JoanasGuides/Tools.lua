--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

--[[ Creature Functions ]]

local dataMineTooltipName = ("%sDatamineTooltip"):format(addonName)
local dataMineTooltip = _G.CreateFrame("GameTooltip", dataMineTooltipName, UIParent, "GameTooltipTemplate")
local dataMineTitleText = _G[("%sDatamineTooltipTextLeft1"):format(addonName)]

local creatureNameCache = { }

function GetCreatureName(creatureID)
	local creatureName = creatureNameCache[creatureID]
	if (not creatureName) then
		dataMineTooltip:SetOwner(UIParent, "ANCHOR_NONE")
		dataMineTooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(creatureID))
		creatureName = dataMineTitleText:GetText()
		if (creatureName) then
			creatureNameCache[creatureID] = creatureName
		end
	end
	return creatureName
end

--[[ Texture Functions ]]

function AddDisabledTexture(frame, texture, width, height, points)
	local _texture = AddTexture(frame, texture, width, height, points)
	frame:SetDisabledTexture(_texture)
	return _texture
end

function AddHighlightTexture(frame, texture, width, height, points)
	if (type(texture) == "table") then
		local _texture = AddTexture(frame, texture.texture, width, height, points)
		frame.highlight = _texture
		frame:SetHighlightTexture(_texture, texture.alphaMode)
		return _texture
	else
		local _texture = AddTexture(frame, texture, width, height, points)
		frame.highlight = _texture
		frame:SetHighlightTexture(_texture)
		return _texture
	end
end

function AddNormalTexture(frame, texture, width, height, points)
	local _texture = AddTexture(frame, texture, width, height, points)
	frame.normal = _texture
	frame:SetNormalTexture(_texture)
	return _texture
end

function AddPushedTexture(frame, texture, width, height, points)
	local _texture = AddTexture(frame, texture, width, height, points)
	frame.pushed = _texture
	frame:SetPushedTexture(_texture)
	return _texture
end

function AddTexture(frame, texture, width, height, points)
	local _texture
	if (type(texture) == "table") then
		_texture = frame:CreateTexture(nil, texture.level or "ARTWORK")
		if (texture.texCoords) then
			--todo: not implemented
		end
		if (texture.drawLayer) then
			_texture:SetDrawLayer(texture.level or "ARTWORK", texture.drawLayer)
		end
		_texture:SetTexture(texture.texture)
	else
		_texture = frame:CreateTexture(nil, "ARTWORK")
		_texture:SetTexture(texture)
	end
	if (width) then
		_texture:SetWidth(width)
	end
	if (height) then
		_texture:SetHeight(height)
	end
	if (points) then
		if (type(points) == "string") then
			_texture:SetPoint(points)
		elseif (type(points == "table")) then
			if (type(points[1]) == "table") then
				for _, v in ipairs(points) do
					_texture:SetPoint(unpack(v))
				end
			else
				_texture:SetPoint(unpack(points))
			end
		end
	elseif (not (width or height)) then
		_texture:SetAllPoints()
	end
	return _texture
end

function CreateTexture(texture, level, texCoords, alphaMode)
	return {
		texture = texture,
		level = level,
		texCoords = texCoords,
		alphaMode = alphaMode
	}
end

--[[ Text Manipulation Functions ]]

function RemoveSpaces(str)
	local newstr = string.gsub(str, "%s+", "")
	return newstr
end

function FormatQuestObjective(objective, questCompleted)
	local _, _, arg1, arg2 = string.find(objective.text, "(.*):%s(.*)");
	if ( arg1 and arg2 ) then
		return ((questCompleted and objective.numRequired) or objective.numFulfilled) .. "/" .. objective.numRequired .. " " .. arg1;
	else
		return objective.text;
	end
end

--[[ Quest Status Functions ]]
function IsQuestAccepted(questID)
	return C_QuestLog.IsOnQuest(questID) or C_QuestLog.IsQuestFlaggedCompleted(questID)
end

function IsQuestCompleted(questID)
	if (C_QuestLog.IsQuestFlaggedCompleted(questID)) then return true end
	if (not C_QuestLog.IsOnQuest(questID)) then return false end
	local questObjectives = C_QuestLog.GetQuestObjectives(questID)
	local questIndex = 1
	while(true) do
		local questLogTitleText, _, _, _, _, isComplete, _, _questID, startEvent = GetQuestLogTitle(questIndex)
		if (questLogTitleText == nil) then return false end
		if (questID == _questID) then
			if (isComplete) then
				if (isComplete == -1) then return false end
				return true
			end
			return not (startEvent or #questObjectives > 0)
		end
		questIndex = questIndex + 1
	end
end

function IsQuestTurnedIn(questID)
	return C_QuestLog.IsQuestFlaggedCompleted(questID)
end

--[[ Spell Lookup Functions ]]
local spellMap = {
	[465] = { 465, 10290, 643, 10291, 1032, 10292, 10293, 27149 }
}

local IsSpellKnown_Orig = IsSpellKnown

IsSpellKnown = function(spellID)
	if (spellMap[spellID]) then
		for _, v in ipairs(spellMap[spellID]) do
			if (IsSpellKnown_Orig(v)) then
				return true
			end
		end
		return false
	end
	return IsSpellKnown_Orig(spellID)
end

--[[ Item Functions ]]

function GetItemLocation(itemId)
	for bagId = 0, 4 do
		for slot = 1, GetContainerNumSlots(bagId) do
			local itemLink = GetContainerItemLink(bagId, slot)
			if (itemLink) then
				local itemId_ = GetItemInfoInstant(itemLink)
				if (itemId == itemId_) then
					return bagId, slot
				end
			end
		end
	end
end

--[[ Map Functions]]

function GetMapName(mapID)
	local mapInfo = C_Map.GetMapInfo(mapID)
	return mapInfo and mapInfo.name
end

--[[ Other Lua/Misc ]]

function selectN(n, ...)
	local n_ = select(n, ...)
	return n_
end

function DefaultTrue(var)
	return var == nil or var == true
end

function DefaultEmptyTable(var)
	return var or { }
end

function DefaultValue(var, default)
	return var ~= nil and var or default
end
