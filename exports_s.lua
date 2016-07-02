function giveCustomWeapon (player, weaponid, ammo, setAsCurrent)
	if not player or getElementType(player) ~= "player" then return false end 
	local playerWeapons = getElementData(player, "weapons")
	if not playerWeapons then return false end 
	if getWeaponByID(weaponid) == false then 
		error("Weapon with id "..weaponid.." does not exists")
	return false end 
	if not ammo then ammo = 30 end 
	if not setAsCurrent then setAsCurrent = true end 
	if playerWeapons[weaponid] then 
		playerWeapons[weaponid].ammo = playerWeapons[weaponid].ammo + ammo
	else 
		playerWeapons[weaponid] = {}
		playerWeapons[weaponid].ammo = ammo 
		-- TODO more parametrs
	end 
	setElementData(player, "weapons", playerWeapons)
	if setAsCurrent == true then 
		local cw = {}
		cw.id = weaponid
		setElementData(player, "current_weapon", cw)
	end
	return true
end

function setPedCustomWeaponSlot (ped, slot)
	if getElementType(ped) ~= "ped" and getElementType(ped) ~= "player" then return false end 
	if not slot then return end 
	if getWeaponByID(slot) == false then 
		error("Weapon with id "..slot.." does not exists")
	return false end 
	local pedWeapons = getElementData(ped, "weapons")
	if not pedWeapons[slot] then 
		error("Ped does not have weapon with id "..slot)
	return false end 
	local cw = {}
	cw.id = slot
	setElementData(ped, "current_weapon", cw)
	return true
end