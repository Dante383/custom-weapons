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
	setElementData(source, "current_weapon", 0) -- fist. 
	giveCustomWeapon(source, 0)
end
addEventHandler("onPlayerConnect", root, onPlayerConnect)




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
			outputChatBox("'current_weapon' is now "..getElementData(source, name))
		end
	end
)
