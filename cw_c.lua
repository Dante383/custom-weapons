local sw,sh = guiGetScreenSize()

local settings = {}
settings["aim"] = "mouse2" -- right click

local temp_variables = {}
temp_variables["aiming"] = false 
temp_variables["crosshair"] = false
temp_variables["crosshair_width"] = false
temp_variables["crosshair_height"] = false  
temp_variables["crosshair_texture"] = false
temp_variables["mouse_x"] = false 
temp_variables["mouse_y"] = false

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
	temp_variables["mouse_x"], temp_variables["mouse_y"] = getCursorPosition()
end

function stopAiming ()
	outputChatBox("stop aiming")
	temp_variables["aiming"] = false 
	temp_variables["crosshair"] = false
	temp_variables["crosshair_width"] = false 
	temp_variables["crosshair_height"] = false
	temp_variables["crosshair_texture"] = false
	temp_variables["crosshair_x"] = false
	temp_variables["crosshair_y"] = false
	temp_variables["mouse_x"] = false
	temp_variables["mouse_y"] = false
	setCameraTarget(localPlayer)
end

function updateMousePosition (x, y)
	temp_variables["mouse_x"], temp_variables["mouse_y"] = x,y 
end

function updateCamera ()
	if temp_variables["aiming"] == true then 
		local x,y,z = getPedBonePosition(localPlayer, 8)
		local x2,y2,z2 = getElementPosition(localPlayer)
		local rotx,roty,rotz = getElementRotation(localPlayer)
		setCameraMatrix(x+3.2, y-1.3, z+0.2)
	end
end
addEventHandler("onClientPreRender", root, updateCamera)

function render()
	if temp_variables["aiming"] == true then 
		dxDrawImage(temp_variables["crosshair_x"], temp_variables["crosshair_y"], temp_variables["crosshair_width"], temp_variables["crosshair_height"],  temp_variables["crosshair_texture"])
	end
end
addEventHandler("onClientRender", root, render)

--[[
useful for developing:
]]

addEventHandler("onClientRender", root,
	function ()
		local currentWeapon = getElementData(localPlayer, "current_weapon")
		dxDrawText("Current weapon: "..currentWeapon.id, 10, 400)
	end
)