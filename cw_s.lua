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
end
addEventHandler("onResourceStart", resourceRoot, init)

function onPlayerConnect ()
	setElementData(source, "weapons", {}) -- here will be stored weapons owned by the player
	local cw = {}
	cw.id = 0
	setElementData(source, "current_weapon", cw) -- fist. 
	giveCustomWeapon(source, 0)
end
addEventHandler("onPlayerConnect", root, onPlayerConnect)

function onSlotChange (plr)
	local currentWeapon = getElementData(plr, "current_weapon")
	if currentWeapon.model then 
		exports['bone_attach']:detachElementFromBone(currentWeapon.model)
		destroyElement(currentWeapon.model)
	end
	local weapon = getWeaponByID(currentWeapon.id)
	if weapon == false then return false end 
	if weapon.modelid then 
		currentWeapon.model = createObject(weapon.modelid, 0,0,0)
		exports['bone_attach']:attachElementToBone(currentWeapon.model, plr, 12, 0, 0, 0, 0, -90, 0)
	end
end

addEventHandler("onElementDataChange", root,
	function (name, oldValue)
		if name == "current_weapon" then 
			onSlotChange(source)
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
