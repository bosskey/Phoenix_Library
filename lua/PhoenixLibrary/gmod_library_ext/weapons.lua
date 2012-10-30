local tblBase = {
	'weapon_pistol',
	'weapon_ar2',
	'weapon_bugbait',
	'weapon_crowbar',
	'weapon_gravgun',
	'weapon_physgun',
	'weapon_smg1',
	'weapon_rpg',
	'weapon_crossbow'
}

weapons.IsValid = function (strClass)
	for k, v in pairs(weapons.GetList()) do
		if v.ClassName == strClass then
			return true
		end
	end
	return table.HasValue(tblBase,strClass)
end