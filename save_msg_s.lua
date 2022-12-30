-- TODO : Improvment to data saving by moving it to client side
-- TODO : Sort messages in data base by acl groups

--* Not Optimized
-- Event to save player chat on db
addEventHandler("onPlayerChat", root, function(msg)
    local type = "chat"
    local playerName = getPlayerName(source) or "NF"
    local realTime = getRealTime()
    local time = string.format("%d/%d/%d %d:%d:%d", 1900 + realTime.year, realTime.month, realTime.monthday, realTime.hour, realTime.minute, realTime.second)
    local group = getPlayerAcls(source)
    local x,y,z = getElementPosition(source)
    local zone = getZoneName(x,y,z)
    local position = string.format("%d,%d,%d", x,y,z)
    savePlayerChat(type, time, playerName, group, msg, zone, position)
end)

addEventHandler("onPlayerCommand", root, function(cmd)
    if cmd == "say" then return end
    local type = "command"
    local playerName = getPlayerName(source) or "NF"
    local realTime = getRealTime()
    local time = string.format("%d/%d/%d %d:%d:%d", 1900 + realTime.year, realTime.month, realTime.monthday, realTime.hour, realTime.minute, realTime.second)
    local group = getPlayerAcls(source)
    local x,y,z = getElementPosition(source)
    local zone = getZoneName(x,y,z)
    local position = string.format("%d,%d,%d", x,y,z)
    savePlayerChat(type, time, playerName, group, "/" .. cmd, zone, position)
end)

-- frees the resault if not saved
function savePlayerChat(type, time, playerName, group, msg, zone, position)
    dbExec(db, "INSERT INTO chats VALUES (?,?,?,?,?,?,?,?)" , _, type, time, playerName, group, msg, zone, position)
end

function savePlayerCommand(type, time, playerName, group, command, zone, position)
    dbExec(db, "INSERT INTO chats VALUES (?,?,?,?,?,?,?,?)" , _, type, time, playerName, group, command, zone, position)
end