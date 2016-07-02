function getWeaponByID (id)
	for k,v in ipairs(weapons) do 
		if tonumber(v["id"]) == id then 
			return v 
		end
	end
	return false
end