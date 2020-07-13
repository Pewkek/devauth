if SERVER then
	hook.Add("CanLuaDev","limitLuaDevAccess", function(ply)
		if(!IsValid(ply)) then return false, "No such player." end
		if(ply:IsDev()) then return true else return false, "You're not a developer." end
	end)

	if(epoe) then
		function CanSubscribe(pl,unsubscribe)
			if(!IsValid(ply)) then return false end
			return pl:IsDev()
		end
	end
end

if CLIENT then
	hook.Add("PlayerInitialSpawn","limitEPOEAccess", function(ply)
		if(!IsValid(ply)) then return end
		if(!ply:IsDev()) then RunConsoleCommand("epoe_ui_remove") end
	end)
end