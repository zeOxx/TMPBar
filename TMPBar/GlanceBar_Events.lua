local GlanceBar = _G["GlanceBar"] or {}

function GlanceBar.RegisterEvents()
	-- Register for events
	EVENT_MANAGER:UnregisterForEvent(GlanceBar.NAME, EVENT_ADD_ON_LOADED)

	EVENT_MANAGER:RegisterForEvent(GlanceBar.NAME, EVENT_MONEY_UPDATE, GlanceBar.UpdateGoldAmount)
	EVENT_MANAGER:RegisterForEvent(GlanceBar.NAME, EVENT_INVENTORY_BOUGHT_BAG_SPACE, GlanceBar.SetBagSlots)
	EVENT_MANAGER:RegisterForEvent(GlanceBar.NAME, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, GlanceBar.SetBagSlots)
	EVENT_MANAGER:RegisterForEvent(GlanceBar.NAME, EVENT_INVENTORY_FULL_UPDATE, GlanceBar.SetBagSlots)
	EVENT_MANAGER:RegisterForEvent(GlanceBar.NAME, EVENT_INVENTORY_ITEM_USED, GlanceBar.SetBagSlots)
	EVENT_MANAGER:RegisterForEvent(GlanceBar.NAME, EVENT_GAME_CAMERA_UI_MODE_CHANGED, GlanceBar.UIChanged)
	EVENT_MANAGER:RegisterForEvent(GlanceBar.NAME, EVENT_CLOSE_BANK, GlanceBar.SetBankBagSlots)
end

function GlanceBar.UpdateGoldAmount(eventCode, newMoney, oldMoney, reason)
	GlanceBar.state.gold = newMoney
	GlanceBar.UpdateUI()
end

function GlanceBar.UIChanged(eventCode)
	if GlanceBar.savedVariables.alwaysShow then
		return
	end

	GlanceBarWindow:SetHidden(IsGameCameraUIModeActive() and GlanceBar.state.lockWindow)
end

-- Make available to other files
_G["GlanceBar"] = GlanceBar