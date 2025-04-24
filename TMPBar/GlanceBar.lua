-- GlanceBar main initialization file
local GlanceBar = _G["GlanceBar"] or {}

function GlanceBar.Init()
	-- Initialize saved variables
	GlanceBar.SavedVarsInit()

	-- Load state data
	GlanceBar.LoadState()

	-- Initialize UI
	GlanceBar.InitUI()

	-- Create settings window
	GlanceBar.CreateSettingsWindow()

	-- Register for events
	GlanceBar.RegisterEvents()
end

function GlanceBar.OnAddOnLoaded(event, addonName)
	if addonName == GlanceBar.NAME then
		GlanceBar.Init()
	end
end

-- Register initial load event
EVENT_MANAGER:RegisterForEvent(GlanceBar.NAME, EVENT_ADD_ON_LOADED, GlanceBar.OnAddOnLoaded)