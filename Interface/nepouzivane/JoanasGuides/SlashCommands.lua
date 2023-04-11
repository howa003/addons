--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local handlers = {
	show = function()
		State.SetGuideShown(true)
	end,
	hide = function()
		State.SetGuideShown(false)
	end,
	enable = function()
		UI.SetMinimapButtonEnabled(true)
	end,
	disable = function()
		UI.SetMinimapButtonEnabled(false)
	end,
	next = function()
		Guide.GotoNextStep(true)
	end,
	back = function()
		Guide.GotoPreviousStep()
	end,
	["debug on"] = function()
		State.SetDebugEnabled(true)
		DEFAULT_CHAT_FRAME:AddMessage("Joana's Guide: debug on")
		DEFAULT_CHAT_FRAME:AddMessage("Current Step: " .. Guide.GetCurrentStep().id)
	end,
	["debug off"] = function()
		State.SetDebugEnabled(false)
		DEFAULT_CHAT_FRAME:AddMessage("Joana's Guide: debug off")
	end,
	["validate guides"] = function()
		ValidateAllGuides()
	end,
	goto = function(msg)
		if (msg ~= nil) then
			Guide.GotoBookmark(msg, true)
		end
	end
}

local function displayHelp()
	DEFAULT_CHAT_FRAME:AddMessage("Show the guide interface: /joana show")
	DEFAULT_CHAT_FRAME:AddMessage("Hide the guide interface: /joana hide")
	DEFAULT_CHAT_FRAME:AddMessage("Enable the minimap button: /joana enable")
	DEFAULT_CHAT_FRAME:AddMessage("Disable the minimap button: /joana disable")
	DEFAULT_CHAT_FRAME:AddMessage("Next step: /joana next")
	DEFAULT_CHAT_FRAME:AddMessage("Previous step: /joana back")
end

local function handleSlashCommand(msg)
	msg = string.lower(msg)
	if (not handlers[msg]) then
		if (string.sub(msg,1,5)=="goto ") then
			handlers.goto(string.sub(msg, 6))
		else
			displayHelp()
		end
	else
		handlers[msg]()
	end
end

_G.SLASH_JOANA1 = "/joana"

SlashCmdList["JOANA"] = handleSlashCommand
