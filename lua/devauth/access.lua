AddCSLuaFile()

if SERVER then
  function DevAuth.LoadUsers()
    DevAuth.Users = {}
    local q = sql.Query("SELECT * FROM devauth;")
    if(q == false or q == nil) then
      return false,q
    elseif(q[1]["steamid"]) then
      for i=1,#q do
        local user = player.GetBySteamID64(q[i]["steamid"])
        if(user) then
          DevAuth.Users[q[i]["steamid"]] = true
        end
      end
    end

    net.Start("DevAuth_SendUsers",false)
      net.WriteTable(DevAuth.Users)
    net.Broadcast()
  end
end

function DevAuth.CheckIfUserExists(sid)
  if(string.len(sid) ~= 17) then return false end
  local LoadedUsers = sql.Query("SELECT * FROM devauth WHERE steamid='"..sql.SQLStr(sid,true).."';")
  if(LoadedUsers == false) then
    return false,LoadedUsers
  elseif(LoadedUsers == nil) then
    return false
  elseif(LoadedUsers) then
    if(LoadedUsers[1]) then
      return true
    end
  end
end

function DevAuth.DelUserID(sid)
  if(type(sid) ~= "string") then return end
  if(!DevAuth.CheckIfUserExists(sid)) then return false,"Cannot find "..sid end
  local q1 = sql.Query("DELETE FROM devauth WHERE steamid='"..sql.SQLStr(sid,true).."';")
  if(q1 == false) then
    return false,q1
  end
  DevAuth.LoadUsers()
  return sid
end



function DevAuth.AddUserID(sid)
  if(type(sid) ~= "string") then return end
  if(DevAuth.CheckIfUserExists(sid)) then return false,"User exists!" end
  local q1 = sql.Query("INSERT INTO devauth (id,steamid) VALUES (null,'"..sql.SQLStr(sid,true).."');")
  if(q1 == false) then
    return false,q1
  end
  DevAuth.LoadUsers()
  return sid
end

function DevAuth.DelUser(ply)
  if(type(ply == "string")) then
    local tgt,err = DevAuth.getUser(ply)
    if(!tgt) then
      return false,err
    else
      local tgt2, err2 = DevAuth.DelUserID(tgt:SteamID64())
      return tgt,err2
    end
  elseif(type(ply) == "player") then
    tgt3, err3 = DevAuth.DelUserID(ply:SteamID64())
    return tgt3, err3
  end
end

function DevAuth.AddUser(ply)
  if(type(ply == "string")) then
    local tgt,err = DevAuth.getUser(ply)
    if(!tgt) then
      return false,err
    else
      local tgt2, err2 = DevAuth.AddUserID(tgt:SteamID64())
      return tgt,err2
    end
  elseif(type(ply) == "player") then
    tgt3, err3 = DevAuth.AddUserID(ply:SteamID64())
    return tgt3, err3
  end
end

if CLIENT then
  AddCSLuaFile()
  if(!DevAuth) then return end
  DevAuth.Users = {}

  net.Receive("DevAuth_SendUsers",function()
    DevAuth.Users = net.ReadTable()
  end)
end



local meta_ply = FindMetaTable("Player")

function meta_ply:IsDev()
  if(!IsValid(self)) then return end
  return DevAuth.Users[self:SteamID64()]
end
