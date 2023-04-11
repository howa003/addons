--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

State = { }

function State.GetBookmark(guide)
	if (guide.info.bookmarks) then
		return SavedVariablesPerCharacter.bookmarks[guide.id]
	end
end

function State.GetGuide()
	return SavedVariablesPerCharacter.lastGuide
end

function State.GetGuideScale()
	return SavedVariables.scale
end

function State.GetWindowLocation()
	return SavedVariables.WindowLocation
end

--todo: Move other saved variables initializers to here
function State.Init()
	_G[SavedVariablesName] = DefaultEmptyTable(_G[SavedVariablesName])
	SavedVariables = _G[SavedVariablesName]
	SavedVariables.scale = DefaultValue(SavedVariables.scale, 1.0)
	SavedVariables.enableStepID = DefaultTrue(SavedVariables.enableStepID)
	SavedVariables.objectiveCompletionSound = DefaultTrue(SavedVariables.objectiveCompletionSound)
	SavedVariables.autoquests = DefaultTrue(SavedVariables.autoquests)
	_G[SavedVariablesPerCharacterName] = DefaultEmptyTable(_G[SavedVariablesPerCharacterName])
	SavedVariablesPerCharacter = _G[SavedVariablesPerCharacterName]
	SavedVariablesPerCharacter.bookmarks = DefaultEmptyTable(SavedVariablesPerCharacter.bookmarks)
end

function State.IsDebugEnabled()
	return SavedVariables and SavedVariables.debug
end

function State.IsGuideShown()
	return SavedVariables.hideGuide ~= true
end

function State.IsStepIDEnabled()
	return SavedVariables.enableStepID
end

function State.IsWindowLocked()
	return SavedVariables.WindowLocked == true
end

function State.SaveBookmark(guideID, stepID)
	SavedVariablesPerCharacter.bookmarks[guideID] = stepID
end

function State.SetDebugEnabled(enabled)
	SavedVariables.debug = enabled
end

function State.SetGuide(guideID)
	SavedVariablesPerCharacter.lastGuide = guideID
end

function State.SetGuideShown(shown)
	if (not InCombatLockdown()) then
		SavedVariables.hideGuide = not shown
		UI.MarkDirty()
	end
end

function State.SetGuideScale(scale)
	SavedVariables.scale = scale
	UI.MarkDirty()
end

function State.SetStepIDEnabled(enabled)
	SavedVariables.enableStepID = enabled
	UI.MarkDirty()
end

function State.SetWindowLocked(locked)
	SavedVariables.WindowLocked = locked
end
