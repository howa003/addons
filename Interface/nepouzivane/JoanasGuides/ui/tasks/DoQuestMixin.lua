--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

DoQuestMixin = Mixin({
	dimmable = true
}, TaskTypeMixin)

function DoQuestMixin:IsCompletedFunc(task)
	local questID = task[self.type]
	local status = QuestStatus.GetQuestStatus(questID)
	local completed = status >= QuestStatus.status.COMPLETED
	if (status >= QuestStatus.status.ACCEPTED and not completed) then
		if (task.objective) then
			local objectives = C_QuestLog.GetQuestObjectives(questID)
			if (objectives and #objectives > 0) then
				return objectives[task.objective].finished
			end
			return false
		end
		--if (task.objectives) then
		--	local objectives = C_QuestLog.GetQuestObjectives(questID)
		--	if (objectives and #objectives > 0) then
		--		for _, idx in ipairs(task.objectives) do
		--			if (not objectives[idx].finished) then
		--				return false
		--			end
		--		end
		--		return true
		--	end
		--	return false
		--end
	end
	return completed
end

function DoQuestMixin:RenderFunc(task, container)
	local name = Names.GetName(C_QuestLog.GetQuestInfo, task[self.type])
	local objectives = C_QuestLog.GetQuestObjectives(task[self.type])
	local questCompleted = C_QuestLog.IsQuestFlaggedCompleted(task[self.type])
	if (objectives) then
		for idx, objective in ipairs(objectives) do
			local detail = container.taskDetailContainers[idx]
			if (objective.finished or questCompleted) then
				UI.SetIconTexture(detail.icon, ICON_COMPLETE)
			else
				UI.SetIconTexture(detail.icon,idx == task.objective and ICON_SPECIFIED_OBJECTIVE or ICON_OBJECTIVE)
			end
			detail:SetAlpha(objective.finished and DIM or 1.0)
			detail:SetShown(true)
			detail.text:SetText(" " .. FormatQuestObjective(objective, questCompleted))
		end
	end
	container.text:SetShown(true)
	container.text:SetText(self.taskPrefix:format(self.taskColor, name))
end
