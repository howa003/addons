--[[ See license.txt for license and copyright information ]]
select(2, ...).SetupGlobalFacade()

local ImageContainer = CreateFrame("Button", nil, UIParent)
ImageContainer:SetFrameStrata("FULLSCREEN")
ImageContainer:SetPoint("TOPLEFT")
ImageContainer:SetPoint("BOTTOMRIGHT")
local blackout = ImageContainer:CreateTexture(nil, "BACKGROUND")
blackout:SetColorTexture(0, 0, 0, 1)
blackout:SetAllPoints()
local imageFrame = ImageContainer:CreateTexture(nil, "ARTWORK")
imageFrame:SetPoint("CENTER")

ImageContainer:Hide()
ImageContainer:SetScript("OnClick", function(self)
	self:Hide()
end)

function ShowImage(image)
	imageFrame:SetTexture(image)
	ImageContainer:Show()
end
