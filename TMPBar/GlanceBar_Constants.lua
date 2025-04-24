-- Constants file for GlanceBar addon
local GlanceBar = GlanceBar or {}

-- Addon constants
GlanceBar.NAME = "GlanceBar"
GlanceBar.VERSION = 6

-- UI elements
GlanceBar.ICONS = {
	GOLD = zo_iconFormat("esoui/art/currency/currency_gold.dds", 16, 16),
	BAG = zo_iconFormat("esoui/art/tooltips/icon_bag.dds", 16, 16),
	BANK = zo_iconFormat("esoui/art/icons/servicemappins/servicepin_bank.dds", 16, 16)
}

-- Default settings
GlanceBar.DEFAULT = {
	BarLocation = "BOTTOMLEFT",
	warningWhen = 15,
	normalColor = { 255, 255, 255, 1 },
	warningColor = { 236, 202, 0, 1 },
	fullColor = { 230, 0, 0, 1 },
	showBankBag = true,
	alwaysShow = false,
	showPercent = false
}

-- Make available to other files
_G["GlanceBar"] = GlanceBar