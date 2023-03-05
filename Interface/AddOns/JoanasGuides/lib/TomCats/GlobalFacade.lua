--[[
GlobalFacade.lua
Copyright (C) 2018-2022 TomCat's Tours
All rights reserved.

For more information, contact via email at tomcat@tomcatstours.com
(or visit https://www.tomcatstours.com)
]]
local globalFacade = { }
globalFacade.addonName, globalFacade.addon = ...

globalFacade._G = _G
globalFacade.SavedVariablesName = ("%s_Account"):format(globalFacade.addonName)
globalFacade.SavedVariablesPerCharacterName = ("%s_Character"):format(globalFacade.addonName)

function globalFacade.getGlobalValue(key)
	return _G[key]
end

function globalFacade.setGlobalValue(key, value)
	_G[key] = value
end

setmetatable(globalFacade, {
	__index = function(self, key)
		local value = rawget(self,key)
		if (not value) then
			return _G[key]
		end
		return value
	end,
	__newindex = function(self, key, value)
		rawset(self, key, value)
	end
})

function globalFacade.addon.SetupGlobalFacade()
	setfenv(2, globalFacade)
end
