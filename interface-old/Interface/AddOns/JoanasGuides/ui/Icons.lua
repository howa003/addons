--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

function UI.SetIconTexture(iconFrame, textureInfo)
	if (textureInfo) then
		iconFrame:SetSize(ICON_SIZE + 2, ICON_SIZE)
		iconFrame.texture:SetScale(textureInfo.scale or 1.0)
		if (textureInfo.atlas) then
			iconFrame.texture:SetAtlas(textureInfo.atlas, textureInfo.useAtlasScale or false)
		else
			iconFrame.texture:SetTexture(textureInfo.texture)
		end
		iconFrame.texture:SetRotation((textureInfo.rotation and (textureInfo.rotation * math.pi / 180)) or 0)
		if (not textureInfo.useAtlasScale) then
			iconFrame.texture:SetSize(textureInfo.width or ICON_SIZE, textureInfo.height or ICON_SIZE)
		end
		iconFrame.texture:ClearAllPoints()
		iconFrame.texture:SetPoint(textureInfo.point or "TOP", textureInfo.offsetX or 0, textureInfo.offsetY or 0)
		iconFrame:Show()
	else
		iconFrame:SetSize(1, ICON_SIZE)
		iconFrame:Hide()
	end
end
