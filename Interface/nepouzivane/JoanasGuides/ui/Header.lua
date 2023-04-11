--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local component = UI.CreateComponent("Header")

function component.Init(components)
	local guideContainer = components.GuideContainer.frame
	local frame = CreateFrame("Frame", nil, guideContainer, "BackdropTemplate")
	frame:SetSize(220, 58)
	frame:SetPoint("TOPLEFT", 40, 0)
	frame.backdropInfo = BACKDROP_GLUE_TOOLTIP_16_16
	frame.backdropColor = GLUE_BACKDROP_COLOR
	frame.backdropColorAlpha = 1.0
	frame.backdropBorderColor = CreateColor(0.78, 0.73, 0.56)
	frame:OnBackdropLoaded()
	frame.IconBorder = frame:CreateTexture(nil, "OVERLAY")
	frame.IconBorder:SetAtlas("auctionhouse-itemicon-border-artifact")
	frame.IconBorder:SetSize(70, 70)
	frame.IconBorder:SetPoint("TOPLEFT", -40, 15)
	frame.Icon = frame:CreateTexture(nil, "ARTWORK")
	frame.Icon:SetTexture(I["JoanasGuidesPortrait"])
	frame.Icon:SetSize(46, 46)
	frame.Icon:SetPoint("CENTER", frame.IconBorder)
	component.frame = frame
end

UI.Add(component)
