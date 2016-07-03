function init ()
	-- disable original weapons
	toggleControl("fire", false)
	toggleControl("next_weapon", false)
	toggleControl("previous_weapon", false)
	toggleControl("aim_weapon", false)
end
addEventHandler("onClientResourceStart", root, init)

function getCrosshairPathByID (id)
	return "img/crosshairs/"..id..".png"
end


--[[
useful for developing:
]]

addEventHandler("onClientRender", root,
	function ()
		local currentWeapon = getElementData(localPlayer, "current_weapon")
		dxDrawText("Current weapon: "..currentWeapon.id, 10, 400)
	end
)