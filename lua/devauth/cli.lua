AddCSLuaFile()


function DevAuth.HandleConsole(ply,cmd,args,argStr)
  if(!args[1] or args[1] == "help") then
    if(CLIENT) then
      MsgC(Color(255,255,255),"\n\n###DevAuth - Help###\n\tdevauth list\tShows currently authed users\n\tdevauth help\tThis message\n\n\n\n\n")
    elseif(SERVER) then
      MsgC(Color(255,255,255),"\n\n###DevAuth - Help###\n\tdevauth list\tShows currently authed users\n\tdevauth help\tThis message\n\tdevauth adduser\tAdds user to developers\n\tdevauth adduserid\tAdds SteamID/SteamID64 to developers\n\tdevauth removeuser\tRemoves user from developers\n\tdevauth removeuserid\tRemoves SteamID/SteamID64 from developers\n\n\n\n\n")
    end
  elseif(args[1] == "list") then
    local AuthedUsersStr = ""
    if(!DevAuth.Users) then
        MsgC(Color(255,255,255),"###DevAuth - Authed users###\n")
        return
    end

    for _,v in pairs(table.GetKeys(DevAuth.Users)) do
      AuthedUsersStr = AuthedUsersStr..player.GetBySteamID64(v):Nick().."\n"
    end
    MsgC(Color(255,255,255),"###DevAuth - Authed users###\n"..AuthedUsersStr.."\n")
  elseif(args[1] == "adduser") then
    if(SERVER) then
      if(args[2]) then
        local tgt,err = DevAuth.AddUser(args[2])
        if(err) then
          MsgC(Color(0,190,255),"[DevAuth] ",Color(255,0,0),"ERROR - "..err.."\n")
        else
          MsgC(Color(0,190,255),"[DevAuth] ",Color(255,255,255),"Added "..tgt:Nick().." to developers group\n")
        end
      else
        MsgC(Color(255,255,255),"devauth adduser\tAdds an user to developers group\n")
      end
    elseif(CLIENT) then
      MsgC(Color(0,190,255),"[DevAuth] ",Color(255,0,0),"You're not authorized\n")
    end
  elseif(args[1] == "removeuser") then
    if(SERVER) then
      if(args[2]) then
        local tgt,err = DevAuth.DelUser(args[2])
        if(err) then
          MsgC(Color(0,190,255),"[DevAuth] ",Color(255,0,0),"ERROR - "..err.."\n")
        else
          MsgC(Color(0,190,255),"[DevAuth] ",Color(255,255,255),"Removed "..tgt:Nick().." from developers group\n")
        end
      else
        MsgC(Color(255,255,255),"devauth removeuser\tRemoves an user from developers group\n")
      end
    elseif(CLIENT) then
      MsgC(Color(0,190,255),"[DevAuth] ",Color(255,0,0),"You're not authorized\n")
    end
  elseif(args[1] == "adduserid") then
    if(SERVER) then
      if(args[2]) then

        local toAdd = DevAuth.ParseSid(args[2])

        print(toAdd)

        if not toAdd then
          MsgC(Color(0, 190, 255), "[DevAuth] ", Color(255, 0, 0), "Error: Cannot determine SteamID type.\n")
        end

        tgt, err = DevAuth.AddUserID(toAdd)
        if(err) then
          MsgC(Color(0,190,255),"[DevAuth] ",Color(255,0,0),"ERROR - "..err.."\n")
          return
        else
          MsgC(Color(0,190,255),"[DevAuth] ",Color(255,255,255),"Added "..toAdd.." to developers group\n")
        end
      else
        MsgC(Color(255,255,255),"devauth adduserid [steamid/steamid64]\tAdds SteamID/SteamID64 to developers group\n")
      end
    elseif(CLIENT) then
      MsgC(Color(0,190,255),"[DevAuth] ",Color(255,0,0),"You're not authorized\n")
    end
  elseif(args[1] == "removeuserid") then
    if(SERVER) then
      if(args[2]) then
        
        local toRem = DevAuth.ParseSid(args[2])

        print(toRem)

        if not toRem then
          MsgC(Color(0, 190, 255), "[DevAuth] ", Color(255, 0, 0), "Error: Cannot determine SteamID type.\n")
        end

        tgt, err = DevAuth.DelUserID(args[2])

        if(err) then
          MsgC(Color(0,190,255),"[DevAuth] ",Color(255,0,0),"ERROR - "..err.."\n")
          return
        else
          MsgC(Color(0,190,255),"[DevAuth] ",Color(255,255,255),"Removed "..tgt.." from developers group\n")
        end
      else
        MsgC(Color(255,255,255),"devauth removeuserid [steamid/steamid64]\tRemoves SteamID/SteamID64 from developers group\n")
      end
    elseif(CLIENT) then
      MsgC(Color(0,190,255),"[DevAuth] ",Color(255,0,0),"You're not authorized\n")
    end
  end
end

concommand.Add("devauth",DevAuth.HandleConsole,nil,"Type devauth help to see available options", FCVAR_NONE)