--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

GetGossipAvailableQuests = GetGossipAvailableQuests or function()
	local availableQuests = C_GossipInfo.GetAvailableQuests()
	local questInfos = { }
	for k, v in ipairs(availableQuests) do
		table.insert(questInfos, v.title)
		table.insert(questInfos, v.questLevel)
		table.insert(questInfos, v.isTrivial)
		table.insert(questInfos, v.frequency)
		table.insert(questInfos, v.repeatable)
		table.insert(questInfos, v.isLegendary)
		table.insert(questInfos, v.isIgnored)
	end
	return unpack(questInfos)
end
GetGossipActiveQuests = GetGossipActiveQuests or function()
	local activeQuests = C_GossipInfo.GetActiveQuests()
	local questInfos = { }
	for k, v in ipairs(activeQuests) do
		table.insert(questInfos, v.title)
		table.insert(questInfos, v.questLevel)
		table.insert(questInfos, v.isTrivial)
		table.insert(questInfos, v.isComplete)
		table.insert(questInfos, v.isLegendary)
		table.insert(questInfos, v.isIgnored)
	end
	return unpack(questInfos)
end
SelectGossipAvailableQuest = SelectGossipAvailableQuest or function(idx)
	local availableQuests = C_GossipInfo.GetAvailableQuests()
	C_GossipInfo.SelectAvailableQuest(availableQuests[idx].questID)
end
SelectGossipActiveQuest = SelectGossipActiveQuest or function(idx)
	local activeQuests = C_GossipInfo.GetActiveQuests()
	C_GossipInfo.SelectActiveQuest(activeQuests[idx].questID)
end
GetContainerNumSlots = GetContainerNumSlots or C_Container.GetContainerNumSlots
GetContainerItemLink = GetContainerItemLink or C_Container.GetContainerItemLink
GetContainerItemCooldown = GetContainerItemCooldown or C_Container.GetContainerItemCooldown
PickupContainerItem = PickupContainerItem or C_Container.PickupContainerItem
