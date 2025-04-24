local GlanceBar = _G["GlanceBar"] or {}

-- State management
GlanceBar.state = {
	gold = 0,
	playerName = "",
	bag = { current = 0, max = 0 },
	bank = { current = 0, max = 0 },
	lockWindow = true
}

function GlanceBar.LoadState()
	GlanceBar.state.playerName = GetUnitName("player")
	GlanceBar.state.gold = GetCurrentMoney("player")

	-- Load bag data
	GlanceBar.state.bag.current = GetNumBagUsedSlots(BAG_BACKPACK)
	GlanceBar.state.bag.max = GetBagSize(BAG_BACKPACK)

	-- Load bank data
	GlanceBar.state.bank.current = GetNumBagUsedSlots(BAG_BANK)
	GlanceBar.state.bank.max = GetBagSize(BAG_BANK)
end

function GlanceBar.SavedVarsInit()
	GlanceBar.savedVariables = ZO_SavedVars:New("GlanceBarVars", GlanceBar.VERSION, nil, GlanceBar.DEFAULT)
end

-- Make available to other files
_G["GlanceBar"] = GlanceBar