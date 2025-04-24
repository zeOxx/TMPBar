local GlanceBar = _G["GlanceBar"] or {}

-- Helper Functions
function GlanceBar.GetAvailableSlots(bagType)
	return GetBagSize(bagType) - GetNumBagUsedSlots(bagType)
end

function GlanceBar.FormatInventoryText(icon, current, max, showPercent)
	local text = icon .. " " .. current .. "/" .. max

	if showPercent then
		local percentage = math.floor((current / max) * 100)
		text = text .. " (" .. percentage .. "%)"
	end

	return text
end

function GlanceBar.GetBagColor(availableSlots)
	if availableSlots == 0 then
		return GlanceBar.savedVariables.fullColor
	elseif availableSlots < (GlanceBar.savedVariables.warningWhen + 1) then
		return GlanceBar.savedVariables.warningColor
	else
		return GlanceBar.savedVariables.normalColor
	end
end

-- Make available to other files
_G["GlanceBar"] = GlanceBar