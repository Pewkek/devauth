if SERVER then util.AddNetworkString("DevAuth_SendUsers") end

if not DevAuth then
  DevAuth = {}
end

if(SERVER) then

if not sql.TableExists("devauth") then
  sql.Query("CREATE TABLE devauth(id INTEGER PRIMARY KEY, steamid TEXT);")
end

MsgC(Color(0,190,255),"[DevAuth] ",Color(255,255,255),"DevAuth initialized")

end

include("devauth/misc.lua")
include("devauth/access.lua")
include("devauth/cli.lua")
include("devauth/permissions.lua")
if(SERVER) then
  hook.Add("PlayerAuthed","DevAuth_RefreshUsers",DevAuth.LoadUsers)
	local postInit = false
	hook.Add("InitPostEntity", "fixULXBots", function()
		hook.Add("CAMI.PlayerHasAccess", "overrideCAMI", function(actorPly)
			if(!IsValid(actorPly)) then return end
			if(actorPly:IsBot()) then return true end
		end)
	end)
end
--[[
if (SERVER) then

local allowedgroups = {
"owner",
"pac3"
}

hook.Add("PrePACConfigApply", "NoYouDont", function(ply, outfit_data)
	if (!table.HasValue(allowedgroups, ply:GetSecondaryUserGroup())) then
		return false, "PAC3 is restricted to allowed user's..."
	end
end)

hook.Add( "PrePACEditorOpen", "NotEvenThis", function( ply )
	if (!table.HasValue(allowedgroups, ply:GetSecondaryUserGroup())) then
		return false
	end
end)

end--]]
