AddCSLuaFile()

function DevAuth.Handle2Errors(tgt1,tgt2,err1,err2)
  if(!tgt1) then
    return false,err1
  else
    if(tgt2) then
      return tgt1
    else
      return false,err2
    end
  end
end

function DevAuth.getUser( target )
  if target == "" then
    return false, "No target specified!"
  end

  local players = player.GetAll()
  target = target:lower()

  local plyMatches = {}

  -- First, do a full name match in case someone's trying to exploit our target system
  for _, player in ipairs( players ) do
    if target == player:Nick():lower() then
      if #plyMatches == 0 then
        return player
      else
        return false, "Found multiple targets! Please choose a better string for the target. (EG, the whole name)"
      end
    end
  end

  for _, player in ipairs( players ) do
    if player:Nick():lower():find( target, 1, true ) then -- No patterns
      table.insert( plyMatches, player )
    end
  end

  if #plyMatches == 0 then
    return false, "No target found or target has immunity!"
  elseif #plyMatches > 1 then
    local str = plyMatches[ 1 ]:Nick()
    for i=2, #plyMatches do
      str = str .. ", " .. plyMatches[ i ]:Nick()
    end

    return false, "Found multiple targets: " .. str .. ". Please choose a better string for the target. (EG, the whole name)"
  end

  return plyMatches[ 1 ]
end