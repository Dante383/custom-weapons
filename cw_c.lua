local sw,sh = guiGetScreenSize()

local settings = {}
settings["aim"] = "mouse2" -- right click

local temp_variables = {}
temp_variables["aiming"] = false 
temp_variables["crosshair"] = false
temp_variables["crosshair_width"] = false
temp_variables["crosshair_height"] = false  
temp_variables["crosshair_texture"] = false

function init ()
	-- disable original weapons
	toggleControl("fire", false)
	toggleControl("next_weapon", false)
	toggleControl("previous_weapon", false)
	toggleControl("aim_weapon", false)
	bindKey(settings["aim"], "down", startAiming)
	bindKey(settings["aim"], "up", stopAiming)
end
addEventHandler("onClientResourceStart", root, init)

function getCrosshairPathByID (id)
	return "img/crosshairs/crosshair_"..id..".png"
end

function startAiming ()
	outputChatBox("start aiming")
	local weapon = getElementData(localPlayer, "current_weapon")
	weapon = getWeaponByID(weapon.id)
	if weapon == false then return end
	if weapon.fire_type == "hand" then return end -- todo
	temp_variables["aiming"] = true 
	temp_variables["crosshair"] = getCrosshairPathByID(weapon.crosshair)
	local ch = fileOpen(temp_variables["crosshair"])
	local pixels = fileRead(ch, fileGetSize(ch))
	fileClose(ch)
	local width, height = dxGetPixelsSize(pixels)
	temp_variables["crosshair_width"] = width
	temp_variables["crosshair_height"] = height
	temp_variables["crosshair_x"] = sw/2
	temp_variables["crosshair_y"] = sh/2
	temp_variables["crosshair_texture"] = dxCreateTexture(temp_variables["crosshair"])
end

function stopAiming ()
	outputChatBox("stop aiming")
	temp_variables["aiming"] = false 
	temp_variables["crosshair"] = false
	temp_variables["crosshair_width"] = false 
	temp_variables["crosshair_height"] = false
	temp_variables["crosshair_texture"] = false
end

addEventHandler("onClientRender", root,
	function ()
		if temp_variables["aiming"] == true then 
			dxDrawImage(temp_variables["crosshair_x"], temp_variables["crosshair_y"], temp_variables["crosshair_width"], temp_variables["crosshair_height"],  temp_variables["crosshair_texture"])
		end
	end
)

--[[
useful for developing:
]]

addEventHandler("onClientRender", root,
	function ()
		local currentWeapon = getElementData(localPlayer, "current_weapon")
		dxDrawText("Current weapon: "..currentWeapon.id, 10, 400)
	end
)