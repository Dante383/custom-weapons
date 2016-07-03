addEvent("fetchWeapons", true)

local weapons = {} 

function getWeaponByID (id)
	for k,v in ipairs(weapons) do 
		if tonumber(v["id"]) == id then 
			return v 
		end
	end
	return false
end

function getCameraRotation ()
    local px, py, pz, lx, ly, lz = getCameraMatrix()
    local rotz = 6.2831853071796 - math.atan2 ( ( lx - px ), ( ly - py ) ) % 6.2831853071796
    local rotx = math.atan2 ( lz - pz, getDistanceBetweenPoints2D ( lx, ly, px, py ) )
    --Convert to degrees
    rotx = math.deg(rotx)
    rotz = -math.deg(rotz)	
    return rotx, 180, rotz
end

addEventHandler("fetchWeapons", root,
	function (weaps)
		weapons = weaps
	end
)
