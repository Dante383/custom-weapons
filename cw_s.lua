weapons = {}

function init ()
	-- load config file 
	local config = xmlLoadFile("config/weapons.xml") 
	local node = xmlNodeGetChildren(config)
	for k,v in ipairs(node) do -- v = <weapon>
		local weapon = {}
		for i,weap in ipairs(xmlNodeGetChildren(v)) do
			weapon[xmlNodeGetName(weap)] = xmlNodeGetValue(weap)
		end
		table.insert(weapons, weapon)
	end
	xmlUnloadFile(config)
	outputDebugString("Loaded "..#weapons.." weapons.")
	setTimer(function() -- mta is too fast :D	
		triggerClientEvent("fetchWeapons", root, weapons)
	end, 500, 1)
end
addEventHandler("onResourceStart", resourceRoot, init)

function deinitialize ()
	for k,v in ipairs(getElementsByType("player")) do 
		local cw = {}
		cw.id = 0
		setElementData(v, "current_weapon", cw)
	end
end
addEventHandler("onResourceStop", resourceRoot, deinitialize)

function onPlayerJoin ()
	setElementData(source, "weapons", {}) -- here will be stored weapons owned by the player
	local cw = {}
	cw.id = 0
	setElementData(source, "current_weapon", cw) -- fist. 
	giveCustomWeapon(source, 0)
end
addEventHandler("onPlayerJoin", root, onPlayerJoin)

function onSlotChange (plr)
	local currentWeapon = getElementData(plr, "current_weapon")
	local temp = getElementData(plr, "cw_temp") -- exist only if weapon has own model. maybe fix it?
	if temp then
		if currentWeapon.id == temp.id then return end
		if getWeaponByID(temp.id).walking_style ~= 0 then 
			exports['bone_attach']:detachElementFromBone(temp.model)
			destroyElement(temp.model)
			local ws = getElementData(plr, "walkingStyle") or 0 
			setPedWalkingStyle(plr, ws)
		end
	end
	local weapon = getWeaponByID(currentWeapon.id)
	if weapon == false then return false end 
	if weapon.modelid then 
		currentWeapon.model = createObject(weapon.modelid, 0,0,0)
		exports['bone_attach']:attachElementToBone(currentWeapon.model, plr, 12, 0, 0, 0, 0, -90, 0)
		setElementData(plr, "walkingStyle", getPedWalkingStyle(plr))
		setPedWalkingStyle(plr, weapon.walking_style)
		setElementData(plr, "cw_temp", currentWeapon)
	else 
		setElementData(plr, "cw_temp", false)
	end
end

function onVehicleEnter (plr)
	setPedCustomWeaponSlot(plr, 0)
end
addEventHandler("onVehicleEnter", root, onVehicleEnter)
addEventHandler("onVehicleStartEnter", root, onVehicleEnter)

addEventHandler("onElementDataChange", root,
	function (name, oldValue)
		if name == "current_weapon" then 
			onSlotChange(source)
		elseif name == "rotz" then 
			setElementRotation(source, 0, 0, getElementData(source, name))
		end
	end
)




--[[
useful for developing:
]]

function giveMeWeapon (plr, cmd, id)
	giveCustomWeapon(plr, id, 10, true)
end
addCommandHandler("giveme", giveMeWeapon)

addEventHandler("onElementDataChange", root,
	function (name,old)
		if name == "weapons" then 
			outputChatBox("'Weapons' changed!")
		elseif name == "current_weapon" then 
			outputChatBox("'current_weapon' is now "..getElementData(source, name).id)
		end
	end
)
