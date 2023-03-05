--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

Guide = { }

local EventFrame = CreateFrame("Frame")

local currentGuide
local currentStep
local guideCache = { }
local guideInfoLookup
local isPlayerMoving = false
local isAutoAdvanceStep = false
local paused = false
local updateCount = 0
local warnings

local EvaluateCurrentStep, EvaluateStep, HasVisibleTaskGroups, LoadGuide, OnEvent, OnUpdate, TryAutoAdvance

function EvaluateCurrentStep()
	EvaluateStep(currentStep)
	if (not Guide.IsStepNodeCompleted(currentStep)) then
		paused = false
	end
end

function EvaluateStep(step)
	if (step.update == updateCount) then return	end
	step.update = updateCount
	-- Evaluate conditions
	step.conditionPassed = CheckCondition(step)
	local conditionPassedTaskGroups = 0
	for _, taskGroup in ipairs(step) do
		taskGroup.conditionPassed = step.conditionPassed and CheckCondition(taskGroup)
		local conditionPassedTasks = 0
		for _, task in ipairs(taskGroup) do
			task.conditionPassed = step.conditionPassed and taskGroup.conditionPassed and CheckCondition(task)
			if (task.conditionPassed) then
				conditionPassedTasks = conditionPassedTasks + 1
			end
		end
		-- If the taskGroup contains no passing tasks, override the taskGroup's evaluation
		if (conditionPassedTasks == 0) then
			taskGroup.conditionPassed = false
		end
		if (taskGroup.conditionPassed) then
			conditionPassedTaskGroups = conditionPassedTaskGroups + 1
		end
	end
	-- If the step contains no passing taskGroups, override the step's evaluation
	if (conditionPassedTaskGroups == 0) then
		step.conditionPassed = false
	end
	-- Evaluate completions
	-- If the step has a "completed" attribute, this will override anything which follows
	step.completedPassed = CheckCompleted(step)
	local completedTaskGroups = 0
	for _, taskGroup in ipairs(step) do
		if (taskGroup.conditionPassed) then
			taskGroup.completedPassed = CheckCompleted(taskGroup)
			taskGroup.optionalPassed = true
			local completedTasks = 0
			for _, task in ipairs(taskGroup) do
				if (task.conditionPassed) then
					task.completedPassed = CheckCompleted(task)
					local taskType = GetTaskType(task)
					if (task.completed == nil) then
						task.completedPassed = taskType:IsCompleted(task)
					end
					if (task.completedPassed or taskType:IsOptional(task)) then
						completedTasks = completedTasks + 1
					end
					if (taskType:IsOptional(task) and not task.completedPassed) then
						taskGroup.optionalPassed = false
					end
				else
					completedTasks = completedTasks + 1
				end
			end
			if (taskGroup.completed == nil) then
				taskGroup.completedPassed = completedTasks == #taskGroup
			end
			if (taskGroup.completedPassed) then
				completedTaskGroups = completedTaskGroups + 1
			end
		else
			completedTaskGroups = completedTaskGroups + 1
		end
	end
	if (step.completed == nil) then
		step.completedPassed = completedTaskGroups == #step
	end
end

function HasVisibleTaskGroups(step)
	for _, taskGroup in ipairs(step) do
		if (CheckCondition(taskGroup)) then
			return true
		end
	end
	return false
end

function LoadGuide(guideID)
	paused = false
	local guide = guideCache[guideID]
	if (not guide) then
		GuideModules.Reload()
		if (not guideInfoLookup) then
			guideInfoLookup = { }
			for _, guideInfo in ipairs(GuideInfos) do
				guideInfoLookup[guideInfo.guideID] = guideInfo
			end
		end
		local guideTemplate = ("%s-%s"):format(addonName, guideID)
		local guideHTML = CreateFrame("SimpleHTML", nil, nil, guideTemplate)
		local regions = { guideHTML:GetRegions() }
		if (not (regions and #regions > 0)) then return end
		local dataParts = { }
		for _, region in ipairs(regions) do
			table.insert(dataParts, RemoveSpaces(region:GetText()))
		end
		guide = loadstring(Base64.decode(table.concat(dataParts)))()
		assert(guide, ("Error extracting guide data: %s"):format(guideID))
		guide.info = guideInfoLookup[guideID]
		assert(guide.info, ("GuideInfo is not present: %s"):format(guideID))
		guide.id = guideID
		for idx, step in ipairs(guide) do
			step.idx = idx
			step.step = step
			for _, taskGroup in ipairs(step) do
				taskGroup.step = step
				taskGroup.parent = step
				for _, task in ipairs(taskGroup) do
					task.step = step
					task.parent = taskGroup
				end
			end
		end
		guideCache[guideID] = guide
	end
	return guide
end

function OnEvent(_, event)
	if (event == "PLAYER_STARTED_MOVING") then
		isPlayerMoving = true
		return
	end
	if (event == "PLAYER_STOPPED_MOVING") then
		isPlayerMoving = false
		return
	end
	if (currentStep) then
		updateCount = updateCount + 1
	end
end

function OnUpdate(_, elapsed)
	if (currentStep) then
		if (isPlayerMoving and currentStep.within and not currentStep.withinCompleted) then
			local x, y = UnitPosition("player")
			if (x) then
				if (currentStep.waypoint and not currentStep.worldPosition) then
					local _, coordinate = C_Map.GetWorldPosFromMapPos(currentStep.map, { x = currentStep.waypoint[1] / 100, y = currentStep.waypoint[2] / 100 })
					currentStep.worldPosition = coordinate
				end
				local distance = addon.GetDistanceInYards(x, y, currentStep.worldPosition.x, currentStep.worldPosition.y)
				currentStep.withinCompleted = distance <= currentStep.within
				if (currentStep.withinCompleted) then updateCount = updateCount + 1 end
			end
		end
		if (currentStep.update ~= updateCount) then
			EvaluateCurrentStep()
			if (TryAutoAdvance()) then return end
			UI.MarkDirty()
			Waypoint.Update()
		end
	end
	UI.Update(elapsed)
end

function TryAutoAdvance()
	local completed = Guide.IsStepNodeCompleted(currentStep)
	if (not completed) then
		paused = false
	elseif (paused == false and Guide.HasNextStep()) then
		Guide.GotoNextStep()
		isAutoAdvanceStep = true
		return true
	end
	return false
end

function Guide.ClearWarnings()
	warnings = nil
	UI.MarkDirty()
end

function Guide.GetCurrentStep()
	return currentStep
end

function Guide.GetCurrentGuide()
	return currentGuide
end

function Guide.GetCurrentStepLocation()
	if (currentStep) then
		if (currentStep.area) then
			return Names.GetName(C_Map.GetAreaInfo, currentStep.area)
		else
			return Names.GetName(GetMapName, currentStep.map)
		end
	end
	return L["Joana's Guides"]
end

function Guide.GetCurrentStepTitle()
	return currentStep and currentStep.title or L["Click cogwheel to load a guide"]
end

function Guide.GetWarnings()
	return warnings
end

function Guide.GotoBookmark(bookmark, paused_)
	if (paused_) then paused = true end
	local lastStep = 1
	bookmark = bookmark or State.GetBookmark(currentGuide)
	local guide = Guide.GetCurrentGuide()
	for idx = 1, #guide do
		local step = guide[idx]
		if (CheckCondition(step)) then
			lastStep = idx
			if (bookmark <= step.id) then
				break
			end
		end
	end
	Guide.SetCurrentStep(lastStep)
	if (not Guide.IsStepNodeCompleted(currentStep)) then
		isAutoAdvanceStep = true
	end
end

function Guide.GotoNextStep(paused_)
	if (paused_ ~= nil) then paused = paused_ end
	if (Guide.HasNextStep()) then
		local lastValidStep = (currentStep and currentStep.idx + 1) or 1
		for idx = lastValidStep, #currentGuide do
			local step = currentGuide[idx]
			EvaluateStep(step)
			if (step.conditionPassed) then
				lastValidStep = idx
				local completed = Guide.IsStepNodeCompleted(step)
				if (paused or not completed) then
					Guide.SetCurrentStep(idx)
					if (paused_ == false) then isAutoAdvanceStep = true end
					return
				end
			end
		end
		Guide.SetCurrentStep(lastValidStep)
		if (paused_ == false) then isAutoAdvanceStep = true end
	end
end

function Guide.GotoPreviousStep(skipCompleted)
	skipCompleted = skipCompleted ~= nil and skipCompleted
	paused = true
	local stepIdx = Guide.GetCurrentStep().idx
	local newStepIdx = 1
	for idx = stepIdx - 1, 1, -1 do
		local step = Guide.GetCurrentGuide()[idx]
		EvaluateStep(step)
		if (CheckCondition(step) and HasVisibleTaskGroups(step)) then
			if (skipCompleted) then
				if (not Guide.IsStepNodeCompleted(step)) then
					newStepIdx = idx
					break
				end
			else
				newStepIdx = idx
				break
			end
		end
	end
	Guide.SetCurrentStep(newStepIdx)
	if (skipCompleted and Guide.HasPreviousStep()) then
		isAutoAdvanceStep = true
	end
end

function Guide.HasNextStep()
	if (currentGuide) then
		for idx = (currentStep and currentStep.idx + 1) or 1, #currentGuide do
			local step = currentGuide[idx]
			EvaluateStep(step)
			if (step.conditionPassed) then
				return true
			end
		end
	end
	return false
end

function Guide.HasPreviousStep()
	if (currentStep) then
		for idx = currentStep.idx - 1, 1, -1 do
			local step = currentGuide[idx]
			EvaluateStep(step)
			if (step.conditionPassed) then
				return true
			end
		end
	end
	return false
end

function Guide.IsAutoAdvanceStep()
	return isAutoAdvanceStep
end

function Guide.IsStepNodeCompleted(node)
	if (node.withinCompleted) then
		return true
	end
	if (node.within) then
		return false
	end
	return node.completedPassed
end

function Guide.SetCurrentStep(stepIdx)
	isAutoAdvanceStep = false
	currentStep = currentGuide[stepIdx]
	currentStep.withinCompleted = nil
	for idx = stepIdx, 1, -1 do
		if (currentStep.title and currentStep.map) then break end
		local step = currentGuide[idx]
		if (step.map or step.title) then
			EvaluateStep(step)
			if (step.conditionPassed) then
				currentStep.map = currentStep.map or step.map
				currentStep.title = currentStep.title or step.title
			end
		end
	end
	EvaluateCurrentStep()
	if (TryAutoAdvance()) then return end
	Debug.AnnounceStep()
	State.SaveBookmark(currentGuide.id, currentStep.id)
	UI.MarkDirty()
	Waypoint.Update()
end

function Guide.SetGuide(guideID, goto)
	currentGuide = nil
	currentStep = nil
	ClearWaypoint()
	ClearAutoQuests()
	if (guideID) then
		State.SetGuide(nil)
		local guide = LoadGuide(guideID)
		if (not guide) then return end
		local moduleInfo = GuideModules.GetModule(guide.info.moduleID)
		if (moduleInfo and moduleInfo.installed and moduleInfo.compatible) then
			currentGuide = guide
			guide.moduleInfo = moduleInfo
			currentStep = nil
			LoadAutoQuests(currentGuide) --todo: Activate autoquests only for currently visible tasks
			State.SetGuide(guideID)
			if (goto) then
				Guide.GotoBookmark(goto)
			else
				local bookmark = State.GetBookmark(guide)
				if (bookmark) then
					Guide.GotoBookmark(bookmark)
				else
					Guide.GotoNextStep()
				end
			end
		else
			UI.MarkDirty()
			Waypoint.Update()
		end
	else
		State.SetGuide()
		UI.MarkDirty()
		Waypoint.Update()
	end
	if (State.IsDebugEnabled()) then
		ValidateGuide()
	end
end

function Guide.SetWarnings(warnings_)
	warnings = warnings_
	UI.MarkDirty()
end

EventFrame:SetScript("OnEvent", OnEvent)
EventFrame:SetScript("OnUpdate", OnUpdate)
EventFrame:RegisterEvent("BAG_UPDATE")
EventFrame:RegisterEvent("HEARTHSTONE_BOUND")
EventFrame:RegisterEvent("PLAYER_LEVEL_UP")
EventFrame:RegisterEvent("QUEST_LOG_UPDATE")
EventFrame:RegisterEvent("UPDATE_FACTION")
EventFrame:RegisterEvent("PLAYER_STARTED_MOVING")
EventFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
