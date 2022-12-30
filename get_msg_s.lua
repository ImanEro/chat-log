local function fetch(player, limit, id, playerName)
    local idQuery,playerQuery,limitQuery = "","",""
    
    if limit then limitQuery = " LIMIT " .. limit end
    if id then idQuery = "id = " .. tostring(id) .. " AND " end
    if playerName then playerQuery = "player = '" .. playerName .. "' AND " end
    
    local qh = dbQuery(db, "SELECT * FROM chats WHERE ".. idQuery .. playerQuery .. " TRUE UNION SELECT * FROM commands WHERE " .. idQuery .. playerQuery .." TRUE " .. limitQuery .. ";")
    local res = dbPoll(qh, -1)
    triggerClientEvent(player, "updateChatLog", player, res)
end
addEvent("fetchChatLog", true)
addEventHandler("fetchChatLog", root, fetch)