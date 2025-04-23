local TMPBar = {}
TMPBar.name = "TMPBar"
TMPBar.gold = 0
TMPBar.maxBagspace = 0
TMPBar.currentBagspace = 0
TMPBar.maxBankBagSpace = 0
TMPBar.currentBankBagSpace = 0
TMPBar.playerName = ""
TMPBar.goldIcon = zo_iconFormat("esoui/art/currency/currency_gold.dds", 16, 16)
TMPBar.bagIcon = zo_iconFormat("esoui/art/tooltips/icon_bag.dds", 16, 16)
TMPBar.bankBagIcon = zo_iconFormat("esoui/art/icons/servicemappins/servicepin_bank.dds", 16, 16)
TMPBar.lockWindow = true

TMPBar.savedVariables = nil
TMPBar.version = 6
TMPBar.default = {
	BarLocation = "BOTTOMLEFT",
	warningWhen = 15,
	normalColor = { 255, 255, 255, 1 },
	warningColor = { 236, 202, 0, 1 },
	fullColor = { 230, 0, 0, 1 },
	showBankBag = true,
	alwaysShow = false,
	showPercent = false
}

function TMPBar.Init()
	TMPBar.playerName = GetUnitName("player")
	TMPBar.gold = GetCurrentMoney("player")
	TMPBar.savedVariables = ZO_SavedVars:New("TMPBarVars", TMPBar.version, nil, TMPBar.default)
	TMPBarWindow:SetMovable(not TMPBar.lockWindow)
	TMPBarWindow:SetMouseEnabled(not TMPBar.lockWindow)

	TMPBar.SetBagSlots()
	TMPBar.SetBankBagSlots()
	TMPBar.SetCash()

	TMPBar.CreateSettingsWindow()

	EVENT_MANAGER:UnregisterForEvent(TMPBar.name, EVENT_ADD_ON_LOADED)

	EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_MONEY_UPDATE, TMPBar.UpdateGoldAmount)
	EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_INVENTORY_BOUGHT_BAG_SPACE, TMPBar.SetBagSlots)
	EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, TMPBar.SetBagSlots)
	EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_INVENTORY_FULL_UPDATE, TMPBar.SetBagSlots)
	EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_INVENTORY_ITEM_USED, TMPBar.SetBagSlots)
	EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_GAME_CAMERA_UI_MODE_CHANGED, TMPBar.UIChanged)
	EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_CLOSE_BANK, TMPBar.SetBankBagSlots)

	TMPBarWindow:SetHandler("OnMoveStop", function(control)
		local x, y = control:GetScreenRect()
		TMPBar.savedVariables.window.x = x
		TMPBar.savedVariables.window.y = y
	end)

	TMPBar.SetWindowPosition()
end

function TMPBar.OnAddOnLoaded(event, addonName)
	if addonName == TMPBar.name then
		TMPBar.Init()
	end
end

function TMPBar.SetBagSlots()
	TMPBar.currentBagspace = GetNumBagUsedSlots(BAG_BACKPACK)
	TMPBar.maxBagspace = GetBagSize(BAG_BACKPACK)

	-- Color code bagspace based on saved range
	if GetBagSize(BAG_BACKPACK) - GetNumBagUsedSlots(BAG_BACKPACK) == 0 then
		TMPBarWindowBagSpaceLabel:SetColor(unpack(TMPBar.savedVariables.fullColor))
	elseif GetBagSize(BAG_BACKPACK) - GetNumBagUsedSlots(BAG_BACKPACK) < (TMPBar.savedVariables.warningWhen + 1) then
		TMPBarWindowBagSpaceLabel:SetColor(unpack(TMPBar.savedVariables.warningColor))
	elseif GetBagSize(BAG_BACKPACK) - GetNumBagUsedSlots(BAG_BACKPACK) > TMPBar.savedVariables.warningWhen then
		TMPBarWindowBagSpaceLabel:SetColor(unpack(TMPBar.savedVariables.normalColor))
	end

	if TMPBar.savedVariables.showPercent then
		TMPBarWindowBagSpaceLabel:SetText(TMPBar.bagIcon .. " " .. TMPBar.currentBagspace .. "/" .. TMPBar.maxBagspace .. " (" .. math.floor((TMPBar.currentBagspace / TMPBar.maxBagspace) * 100) .. "%)")
		return
	end

	TMPBarWindowBagSpaceLabel:SetText(TMPBar.bagIcon .. " " .. TMPBar.currentBagspace .. "/" .. TMPBar.maxBagspace)
end

function TMPBar.SetBankBagSlots()
	TMPBar.currentBankBagSpace = GetNumBagUsedSlots(BAG_BANK)
	TMPBar.maxBankBagSpace = GetBagSize(BAG_BANK)

	if TMPBar.savedVariables.showPercent then
		TMPBarWindowBankSpaceLabel:SetText(TMPBar.bankBagIcon .. " " .. TMPBar.currentBankBagSpace .. "/" .. TMPBar.maxBankBagSpace .. " (" .. math.floor((TMPBar.currentBankBagSpace / TMPBar.maxBankBagSpace) * 100) .. "%)")
		return
	end

	TMPBarWindowBankSpaceLabel:SetHidden(not TMPBar.savedVariables.showBankBag)
	TMPBarWindowBankSpaceLabel:SetText(TMPBar.bankBagIcon .. " " .. TMPBar.currentBankBagSpace .. "/" .. TMPBar.maxBankBagSpace)
end

function TMPBar.SetCash()
	TMPBarWindowGoldLabel:SetText(TMPBar.goldIcon .. " " .. TMPBar.gold)
end

function TMPBar.UpdateGoldAmount(eventCode, newMoney, oldMoney, reason)
	TMPBar.gold = newMoney
	TMPBar.SetCash()
end

function TMPBar.UIChanged(eventCode)
	if TMPBar.savedVariables.alwaysShow then
		return
	end

	if IsGameCameraUIModeActive() and TMPBar.lockWindow then
		TMPBarWindow:SetHidden(true)
	else
		TMPBarWindow:SetHidden(false)
	end
end

function TMPBar.SetWindowPosition()
	if TMPBar.savedVariables.window ~= nil then
		TMPBarWindow:ClearAnchors()
		TMPBarWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, TMPBar.savedVariables.window.x, TMPBar.savedVariables.window.y)
	else
		local x, y = TMPBarWindow:GetScreenRect()
		TMPBar.savedVariables.window = { x=x, y=y }
	end
end

function TMPBar.CreateSettingsWindow()
	local LAM = LibAddonMenu2

	local panelData = {
		type = "panel",
		name = "TMPBar",
		displayName = "TMPBar",
		author = "zeOx",
		version = "1.0",
		slashCommand = "/TMPBar",
		registerForRefresh = true,
		registerForDefaults = true,
	}

	local cntrlOptionsPanel = LAM:RegisterAddonPanel("TMPBar", panelData)

	-- Table time!
	local optionsData = {
		[1] = {
			type = "header",
			name = "General"
		},
		[2] = {
			type = "checkbox",
			name = "Lock",
			tooltip = "Unlock to position manually",
			default = true,
			getFunc = function ()
						return TMPBar.lockWindow
					end,
			setFunc = function (newValue)
						TMPBar.lockWindow = newValue
						TMPBarWindow:SetMovable(not TMPBar.lockWindow)
						TMPBarWindow:SetMouseEnabled(not TMPBar.lockWindow)

						if TMPBar.savedVariables.alwaysShow then
							return
						end

						if not TMPBar.lockWindow then
							TMPBarWindow:SetHidden(false)
						else
							TMPBarWindow:SetHidden(true)
						end
					end
		},
		[3] = {
			type = "checkbox",
			name = "Always show",
			default = false,
			getFunc = function ()
						return TMPBar.savedVariables.alwaysShow
					end,
			setFunc = function (newValue)
						TMPBar.savedVariables.alwaysShow = newValue
						TMPBarWindow:SetHidden(not TMPBar.savedVariables.alwaysShow)
					end
		},
		[4] = {
			type = "button",
			name = "Reset position",
			tooltip = "Resets the position of TMPBar",
			func = function ()
					TMPBarWindow:ClearAnchors()
					TMPBarWindow:SetAnchor(LEFT, GuiRoot, BOTTOMLEFT, 10, -15)
					TMPBar.savedVariables.window = nil
				end
		},
		[5] = {
			type = "header",
			name = "Bag options"
		},
		[6] = {
			type = "checkbox",
			name = "Show bank bag",
			tooltip = "Determine wether or not your bank bag is shown",
			default = true,
			getFunc = function ()
						return TMPBar.savedVariables.showBankBag
					end,
			setFunc = function (newValue)
						TMPBar.savedVariables.showBankBag = newValue
						TMPBarWindowBankSpaceLabel:SetHidden(not newValue)
					end
		},
		[7] = {
			type = "colorpicker",
			name = "Normal color",
			tooltip = "Changes the normal color of the bag text.",
			getFunc = function ()
						return unpack(TMPBar.savedVariables.normalColor)
					end,
			setFunc = function (r, g, b, a)
						TMPBar.savedVariables.normalColor = { r, g, b, a }
					end
		},
		[8] = {
			type = "colorpicker",
			name = "Warning color",
			tooltip = "Changes the warning color of the bag text.",
			getFunc = function ()
						return unpack(TMPBar.savedVariables.warningColor)
					end,
			setFunc = function (r, g, b, a)
						TMPBar.savedVariables.warningColor = { r, g, b, a }
					end
		},
		[9] = {
			type = "colorpicker",
			name = "Full color",
			tooltip = "Changes the color of the bag text when bags are full.",
			getFunc = function ()
						return unpack(TMPBar.savedVariables.fullColor)
					end,
			setFunc = function (r, g, b, a)
						TMPBar.savedVariables.fullColor = { r, g, b, a }
					end
		},
		[10] = {
			type = "dropdown",
			name = "Warning",
			tooltip = "Choose when to set the warningcolor on the bag text",
			choices = { 5, 10, 15, 20 },
			getFunc = function ()
						return TMPBar.savedVariables.warningWhen
					end,
			setFunc = function (newValue)
						TMPBar.savedVariables.warningWhen = newValue
					end
		},
		[11] = {
			type = "checkbox",
			name = "Show percentage",
			tooltip = "Determine wether or not the percentage is shown",
			default = true,
			getFunc = function ()
						return TMPBar.savedVariables.showPercent
					end,
			setFunc = function (newValue)
						TMPBar.savedVariables.showPercent = newValue
						TMPBar.SetBagSlots()
						TMPBar.SetBankBagSlots()
					end
		},
	}

	LAM:RegisterOptionControls("TMPBar", optionsData)
end

-- EVENTS!
EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_ADD_ON_LOADED, TMPBar.OnAddOnLoaded)