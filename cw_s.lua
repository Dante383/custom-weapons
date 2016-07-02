local weapons = {}

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