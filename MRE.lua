local SCALE = 1
local FONT_HEIGHT = 25 -- 25 is max
local FONT = [[Fonts\FRIZQT__.ttf]]
local COLOR = {
	[0] = { r = 0, g = 0, b = 1 }, -- Mana
	[1] = { r = 1, g = 0, b = 0 }, -- Rage
	[3] = { r = 1, g = 1, b = 0 }, -- Energy
}

local frame = CreateFrame('Frame', "MREFrame", UIParent)
frame:SetWidth(FONT_HEIGHT)
frame:SetHeight(FONT_HEIGHT)
frame:SetPoint('CENTER', 0, 0)
frame:SetScale(SCALE)

local text = frame:CreateFontString("$parentText", "BACKGROUND")
text:SetFontObject(ZoneTextFont)
text:SetPoint('CENTER', 0, 0)
text:SetFont(FONT, FONT_HEIGHT, 'OUTLINE')
text:SetJustifyH('CENTER')
text:SetTextHeight(FONT_HEIGHT * SCALE)

frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:RegisterForDrag('LeftButton')
frame:SetScript('OnUpdate', function() this:EnableMouse(IsAltKeyDown() or this.dragging) end)
frame:SetScript('OnDragStart', function() this.dragging = true this:StartMoving() end)
frame:SetScript('OnDragStop', function() this.dragging = false this:StopMovingOrSizing() MRE_POSITION = {frame:GetCenter()} end)
frame:SetScript('OnEvent', function()
	if event ~= 'PLAYER_LOGIN' then
		if arg1 ~= 'player' then return end
	else
		frame:ClearAllPoints()
		frame:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', unpack(MRE_POSITION or {frame:GetCenter()}))
	end
	local fraction = UnitMana('player') / UnitManaMax('player')
	for component, value in pairs(COLOR[UnitPowerType('player')]) do
		text[component] = value * fraction + (1 - fraction)
	end
	text:SetText(UnitMana('player'))
	frame:SetWidth(text:GetStringWidth())
	text:SetTextColor(text.r, text.g, text.b)
end)
for _, event in {'PLAYER_LOGIN', 'UNIT_MANA', 'UNIT_MAXMANA', 'UNIT_RAGE', 'UNIT_MAXRAGE', 'UNIT_ENERGY', 'UNIT_MAXENERGY', "UNIT_DISPLAYPOWER"} do
	frame:RegisterEvent(event)
end