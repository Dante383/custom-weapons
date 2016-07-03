addEvent("setAnimation", true)

function getWeaponByID (id)
	for k,v in ipairs(weapons) do 
		if tonumber(v["id"]) == id then 
			return v 
		end
	end
	return false
end

addEventHandler("setAnimation", root,
	function (block, animation)
		setPedAnimation(source, block, animation, -1, false, true, false, true)
	end
)