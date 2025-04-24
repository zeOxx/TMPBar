local GlanceBar = _G["GlanceBar"] or {}

function GlanceBar.InitUI()
	GlanceBarWindow:SetMovable(not GlanceBar.state.lockWindow)
	GlanceBarWindow:SetMouseEnabled(not GlanceBar.state.lockWindow)

	GlanceBarWindow:SetHandler("OnMoveStop", function(control)
		local x, y = control:GetScreenRect()
		GlanceBar.savedVariables.window.x = x
		GlanceBar.savedVariables.window.y = y
	end)

	GlanceBar.SetWindowPosition()
	GlanceBar.UpdateUI()
end

function GlanceBar.SetBagSlots()
	GlanceBar.state.bag.current = GetNumBagUsedSlots(BAG_BACKPACK)
	GlanceBar.state.bag.max = GetBagSize(BAG_BACKPACK)
	GlanceBar.UpdateUI()
end

function GlanceBar.SetBankBagSlots()
	GlanceBar.state.bank.current = GetNumBagUsedSlots(BAG_BANK)
	GlanceBar.state.bank.max = GetBagSize(BAG_BANK)
	GlanceBar.UpdateUI()
end

function GlanceBar.UpdateUI()
	-- Update bag display
	local availableBagSlots = GlanceBar.GetAvailableSlots(BAG_BACKPACK)
	local bagText = GlanceBar.FormatInventoryText(
		GlanceBar.ICONS.BAG,
		GlanceBar.state.bag.current,
		GlanceBar.state.bag.max,
		GlanceBar.savedVariables.showPercent
	)

	GlanceBarWindowBagSpaceLabel:SetText(bagText)
	GlanceBarWindowBagSpaceLabel:SetColor(unpack(GlanceBar.GetBagColor(availableBagSlots)))

	-- Update bank display
	local bankText = GlanceBar.FormatInventoryText(
		GlanceBar.ICONS.BANK,
		GlanceBar.state.bank.current,
		GlanceBar.state.bank.max,
		GlanceBar.savedVariables.showPercent
	)

	GlanceBarWindowBankSpaceLabel:SetText(bankText)
	GlanceBarWindowBankSpaceLabel:SetHidden(not GlanceBar.savedVariables.showBankBag)

	-- Update gold display
	GlanceBarWindowGoldLabel:SetText(GlanceBar.ICONS.GOLD .. " " .. GlanceBar.state.gold)
end

function GlanceBar.SetWindowPosition()
	if GlanceBar.savedVariables.window ~= nil then
		GlanceBarWindow:ClearAnchors()
		GlanceBarWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, GlanceBar.savedVariables.window.x, GlanceBar.savedVariables.window.y)
	else
		local x, y = GlanceBarWindow:GetScreenRect()
		GlanceBar.savedVariables.window = { x=x, y=y }
	end
end

-- Make available to other files
_G["GlanceBar"] = GlanceBar