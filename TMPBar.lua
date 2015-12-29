TMPBar = {}
TMPBar.name = "TMPBar"
TMPBar.gold = 0
TMPBar.maxBagspace = 0
TMPBar.currentBagspace = 0
TMPBar.playerName = ""
TMPBar.goldIcon = zo_iconFormat("esoui/art/currency/currency_gold.dds", 16, 16)
TMPBar.bagIcon = zo_iconFormat("esoui/art/tooltips/icon_bag.dds", 16, 16)

function TMPBar:Init()
	TMPBar.playerName = GetUnitName("player")
	d(TMPBar.playerName)
	TMPBar.SetBagSlots()
	TMPBar.gold = GetCurrentMoney("player")
	TMPBar.SetCash()

	EVENT_MANAGER:UnregisterForEvent(TMPBar.name, EVENT_ADD_ON_LOADED)
end

function TMPBar.OnAddOnLoaded(event, addonName)
	if addonName == TMPBar.name then
		TMPBar:Init()
	end
end

function TMPBar.UpdateGoldAmount(eventCode, newMoney, oldMoney, reason)
	--d("Gold received: " .. newMoney - oldMoney)
	TMPBar.gold = newMoney - oldMoney
	TMPBar.SetCash()
	TMPBar.SetBagSlots()
end

function TMPBar.UIChanged(eventCode)
	if IsGameCameraUIModeActive() then
        TMPBarWindow:SetHidden(true)
    else
        TMPBarWindow:SetHidden(false)
    end
end

function TMPBar.SetBagSlots()
	TMPBar.currentBagspace = GetNumBagUsedSlots(BAG_BACKPACK)
	TMPBar.maxBagspace = GetBagSize(BAG_BACKPACK)

	if TMPBar.maxBagspace - TMPBar.currentBagspace == 0 then
		TMPBarWindowBagSpaceLabel:SetColor(229, 0, 0)
	elseif TMPBar.maxBagspace - TMPBar.currentBagspace < 16 then
		TMPBarWindowBagSpaceLabel:SetColor(236, 202, 0)
	elseif TMPBar.maxBagspace - TMPBar.currentBagspace > 15 then
		TMPBarWindowBagSpaceLabel:SetColor(255, 255, 255)
	end 

	--d("Bagspace: " .. TMPBar.currentBagspace .. "/" .. TMPBar.maxBagspace)
	TMPBarWindowBagSpaceLabel:SetText(TMPBar.bagIcon .. TMPBar.currentBagspace .. "/" .. TMPBar.maxBagspace)
end

function TMPBar.SetCash()
	TMPBarWindowGoldLabel:SetText(TMPBar.goldIcon .. TMPBar.gold)
end

EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_ADD_ON_LOADED, TMPBar.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_MONEY_UPDATE, TMPBar.UpdateGoldAmount)
EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_INVENTORY_BOUGHT_BAG_SPACE, TMPBar.SetBagSlots)
EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, TMPBar.SetBagSlots)
EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_INVENTORY_FULL_UPDATE, TMPBar.SetBagSlots)
EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_INVENTORY_ITEM_USED, TMPBar.SetBagSlots)
EVENT_MANAGER:RegisterForEvent(TMPBar.name, EVENT_GAME_CAMERA_UI_MODE_CHANGED, TMPBar.UIChanged)