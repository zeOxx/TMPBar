local GlanceBar = _G["GlanceBar"] or {}

function GlanceBar.CreateSettingsWindow()
	local LAM = LibAddonMenu2

	local panelData = {
		type = "panel",
		name = "GlanceBar",
		displayName = "GlanceBar",
		author = "zeOx",
		version = "1.3",
		slashCommand = "/GlanceBar",
		registerForRefresh = true,
		registerForDefaults = true,
	}

	local optionsPanel = LAM:RegisterAddonPanel("GlanceBar", panelData)

	-- Create settings options
	local optionsData = {}

	-- Add general options section
	table.insert(optionsData, GlanceBar.GetGeneralOptions())

	-- Add bag options section
	table.insert(optionsData, GlanceBar.GetBagOptions())

	-- Register all controls
	LAM:RegisterOptionControls("GlanceBar", optionsData)
end

function GlanceBar.GetGeneralOptions()
	local generalOptions = {
		{
			type = "header",
			name = "General"
		},
		{
			type = "checkbox",
			name = "Lock",
			tooltip = "Unlock to position manually",
			default = true,
			getFunc = function() return GlanceBar.state.lockWindow end,
			setFunc = function(newValue)
				GlanceBar.state.lockWindow = newValue
				GlanceBarWindow:SetMovable(not GlanceBar.state.lockWindow)
				GlanceBarWindow:SetMouseEnabled(not GlanceBar.state.lockWindow)

				if GlanceBar.savedVariables.alwaysShow then return end

				GlanceBarWindow:SetHidden(GlanceBar.state.lockWindow and IsGameCameraUIModeActive())
			end
		},
		{
			type = "checkbox",
			name = "Always show",
			default = false,
			getFunc = function() return GlanceBar.savedVariables.alwaysShow end,
			setFunc = function(newValue)
				GlanceBar.savedVariables.alwaysShow = newValue
				GlanceBar.UIChanged()
			end
		},
		{
			type = "button",
			name = "Reset position",
			tooltip = "Resets the position of GlanceBar",
			func = function()
				GlanceBarWindow:ClearAnchors()
				GlanceBarWindow:SetAnchor(LEFT, GuiRoot, BOTTOMLEFT, 10, -15)
				GlanceBar.savedVariables.window = nil
			end
		}
	}

	return generalOptions
end

function GlanceBar.GetBagOptions()
	local bagOptions = {
		{
			type = "header",
			name = "Bag options"
		},
		{
			type = "checkbox",
			name = "Show bank bag",
			tooltip = "Determine whether or not your bank bag is shown",
			default = true,
			getFunc = function() return GlanceBar.savedVariables.showBankBag end,
			setFunc = function(newValue)
				GlanceBar.savedVariables.showBankBag = newValue
				GlanceBarWindowBankSpaceLabel:SetHidden(not newValue)
			end
		},
		{
			type = "colorpicker",
			name = "Normal color",
			tooltip = "Changes the normal color of the bag text.",
			getFunc = function() return unpack(GlanceBar.savedVariables.normalColor) end,
			setFunc = function(r, g, b, a)
				GlanceBar.savedVariables.normalColor = { r, g, b, a }
				GlanceBar.UpdateUI()
			end
		},
		{
			type = "colorpicker",
			name = "Warning color",
			tooltip = "Changes the warning color of the bag text.",
			getFunc = function() return unpack(GlanceBar.savedVariables.warningColor) end,
			setFunc = function(r, g, b, a)
				GlanceBar.savedVariables.warningColor = { r, g, b, a }
				GlanceBar.UpdateUI()
			end
		},
		{
			type = "colorpicker",
			name = "Full color",
			tooltip = "Changes the color of the bag text when bags are full.",
			getFunc = function() return unpack(GlanceBar.savedVariables.fullColor) end,
			setFunc = function(r, g, b, a)
				GlanceBar.savedVariables.fullColor = { r, g, b, a }
				GlanceBar.UpdateUI()
			end
		},
		{
			type = "dropdown",
			name = "Warning",
			tooltip = "Choose when to set the warning color on the bag text",
			choices = { 5, 10, 15, 20 },
			getFunc = function() return GlanceBar.savedVariables.warningWhen end,
			setFunc = function(newValue)
				GlanceBar.savedVariables.warningWhen = newValue
				GlanceBar.UpdateUI()
			end
		},
		{
			type = "checkbox",
			name = "Show percentage",
			tooltip = "Determine whether or not the percentage is shown",
			default = false,
			getFunc = function() return GlanceBar.savedVariables.showPercent end,
			setFunc = function(newValue)
				GlanceBar.savedVariables.showPercent = newValue
				GlanceBar.UpdateUI()
			end
		}
	}

	return bagOptions
end

-- Make available to other files
_G["GlanceBar"] = GlanceBar