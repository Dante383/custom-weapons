addEvent("setAnimation", true)

local sw,sh = guiGetScreenSize()

local settings = {}
settings["aim"] = "mouse2" -- right click
settings["shot"] = "mouse1" -- left click

local temp_variables = {}
temp_variables["aiming"] = false 
temp_variables["crosshair"] = false
temp_variables["crosshair_width"] = false
temp_variables["crosshair_height"] = false  
temp_variables["crosshair_texture"] = false
temp_variables["mouse_x"] = false 
temp_variables["mouse_y"] = false
temp_variables["weapon"] = false

function init ()
	-- disable original weapons
	toggleControl("fire", false)
	toggleControl("next_weapon", false)
	toggleControl("previous_weapon", false)
	toggleControl("aim_weapon", false)
	bindKey(settings["aim"], "down", startAiming)
	bindKey(settings["aim"], "up", stopAiming)
	bindKey(settings["shot"], "down", shotStart)
	bindKey(settings["shot"], "up", shotStop)
end
addEventHandler("onClientResourceStart", root, init)

function getCrosshairPathByID (id)
	return "img/crosshairs/crosshair_"..id..".png"
end

function getCrosshairPosition ()
	return sw/2, sh/2
end

function startAiming ()
	if getPedOccupiedVehicle(localPlayer) then return end
	outputChatBox("start aiming", 0, 255, 0)
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
	temp_variables["weapon_data"] = weapon
	if weapon.fire_type == "ih" then 
		local x,y,z = getPedBonePosition(localPlayer, 8)
		temp_variables["weapon"] = createWeapon("m4", x, y, z)
		setElementAlpha(temp_variables["weapon"], 0)
		exports['bone_attach']:attachElementToBone(temp_variables["weapon"], localPlayer, 12, 0, 0, 0, 0, -90, 0)
	end
	-- everything below needs rewrite when i find a way to write it better
	triggerServerEvent("setAnimation", localPlayer, "SHOP", "SHP_Gun_Aim")
end

function stopAiming ()
	outputChatBox("stop aiming", 255, 0, 0)
	temp_variables["aiming"] = false 
	temp_variables["crosshair"] = false
	temp_variables["crosshair_width"] = false 
	temp_variables["crosshair_height"] = false
	temp_variables["crosshair_texture"] = false
	temp_variables["crosshair_x"] = false
	temp_variables["crosshair_y"] = false
	if isElement(temp_variables["weapon"]) then
		exports['bone_attach']:detachElementFromBone(temp_variables["weapon"])
		destroyElement(temp_variables["weapon"])
	end
	temp_variables["weapon"] = false
	--setCameraTarget(localPlayer)
	triggerServerEvent("setAnimation", localPlayer, nil, nil)
end

function shot ()
	if temp_variables["aiming"] == false then return end 
	fireWeapon(temp_variables["weapon"])
end

function shotStart ()
	if temp_variables["aiming"] == false then return end 
	temp_variables["timer"] = setTimer(shot, temp_variables["weapon_data"].speed, 0)
end

function shotStop ()
	if isTimer(temp_variables["timer"]) then
		killTimer(temp_variables["timer"])
	end
end

function updateCamera ()
	if temp_variables["aiming"] == true then
		--[[
		local x,y,z = getPedBonePosition(localPlayer, 8)
		local x2,y2,z2 = getElementPosition(localPlayer)
		local rotx,roty,rotz = getElementRotation(localPlayer)
		local radRot = math.rad(rotz)
		local radius = .5
		local tx = x + radius * math.sin(radRot)
		local ty = y + -(radius) * math.cos(radRot)
		local tz = z
		setCameraMatrix(tx+2, ty-0.5, tz+0.2, x3, y3, z3)
		]]
		if not temp_variables["weapon"] then return end 
		local mx,my = getCrosshairPosition()
		local x,y,z = getWorldFromScreenPosition(mx, my, 10)
		--setWeaponTarget(temp_variables["weapon"], x, y, z)
		local rotx,roty,rotz = getCameraRotation()
		setElementData(localPlayer, "rotz", 360-rotz) -- it will be set serverside
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